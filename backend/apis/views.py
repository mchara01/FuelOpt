from django.http.response import HttpResponse
from django.shortcuts import render,redirect
from stations.models import FuelPrice, Station
from rest_framework import generics
from django.contrib import messages
import pandas as pd
import time
import math
import urllib.request
import json
from django.db import connection
from django.http import JsonResponse
from decimal import Decimal
# Create your views here.
from stations import models
from .serializers import StationSerializer

class ListStation(generics.ListCreateAPIView):
    queryset = models.Station.objects.all() 
    serializer_class = StationSerializer

class DetailStation(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Station.objects.all()
    serializer_class = StationSerializer

def temp_admin(request):

    if request.method == 'POST':
        #Handle login
        if('restartEntries') in request.POST:
            messages.success(request,'Stations Database Restarted (and fuel prices updated)')
            restartStationEntries()
            updateEntries()
            return redirect('apis:temp_admin')
        if('updateEntries') in request.POST:
            messages.success(request,'Fuel Prices Updated')
            updateEntries()
            return redirect('apis:temp_admin')
        if('deleteFuelPrices') in request.POST:
            messages.success(request,'Fuel Prices Deleted')
            deleteFuelPrices()
            return redirect('apis:temp_admin')
            
    return render(request,'apis/temp_admin.html')

def restartStationEntries():
    Station.objects.all().delete()

    data = pd.read_csv('../data/db_scripts/stations_with_coordinates.csv')

    postcodes = []
    streets = []

    for full_address in data["station_location"]:
        street, postcode = full_address.split(", ")
        postcodes.append(postcode)
        streets.append(street)

    data["street"] = streets
    data["postcode"] = postcodes
    data = data.drop("station_location", axis=1)
    data = data.drop("Unnamed: 0", axis=1)

    # insert the station information to the database
    print("Inserting station information to database:")
    for index, row in data.iterrows():
        print("\t",index, "/ 777")

        station = Station(name = row["name"].strip(), street =row["street"].strip() , postcode=row["postcode"].strip() ,lat=row["lat"],lng=row["lng"],station_ref=row["station_id"])
        station.save()

        # add a second delay to not overwhelm the database
        if (index % 200 == 0):
            time.sleep(1)

    print("Done inserting station information to database.")
    return

def updateEntries():
    data = pd.read_csv('../data/db_scripts/stations_all_info.csv')

    print("Updating fuel prices information to database:")
    for index, row in data.iterrows():
        print("\t",index, "/ 777")
        station = Station.objects.filter(station_ref=row["station_id"]).first()

        unleaded = None
        diesel = None
        super_unleaded = None
        premium_diesel = None
        if(not math.isnan(row["unleaded"])):
            unleaded = row["unleaded"]
        if(not math.isnan(row["diesel"])):
            diesel = row["diesel"]
        if(not math.isnan(row["super_unleaded"])):
            super_unleaded = row["super_unleaded"]
        if(not math.isnan(row["premium_diesel"])):
            premium_diesel = row["premium_diesel"]

        fuelPrice = FuelPrice(station=station, unleaded_price=unleaded,diesel_price=diesel,super_unleaded_price=super_unleaded, premium_diesel_price=premium_diesel)
        fuelPrice.save()

        # add a second delay to not overwhelm the database
        if (index % 200 == 0):
            time.sleep(1)
    print("Done updating fuel information to database.")

    return

def deleteFuelPrices():
    FuelPrice.objects.all().delete()

def home(request):
    """
    home API returns the client a json list of all petrol stations visible within a user's viewport when the 
    app is first opened (homepage).
    API called via a GET Request.
    Example API call: http://127.0.0.1:8000/apis/home/?lat_max=51.5&lat_min=51.4&lng_max=-0.06&lng_min=-0.09
    """
    if request.method == 'GET':
        # Get the bounding box, sent via query string issued by flutter
        lat_max = request.GET['lat_max']
        lat_min = request.GET['lat_min']
        lng_max = request.GET['lng_max']
        lng_min = request.GET['lng_min']

        # Show stations within the page view
        stations_near_me = Station.objects.filter(
            lat__lte=lat_max, lat__gte=lat_min, lng__lte=lng_max, lng__gte=lng_min
        )
    
    # returns a Json list of stations within that page
    return JsonResponse([station.serialize() for station in stations_near_me], safe=False)

def nearestStation(request):
    """
    nearestStation API returns the client a json list of all the petrol stations nearest to the user-specified location
    according to user preference selection.
    API called via a GET Request.
    Example API call: http://127.0.0.1:8000/apis/nearestStation/
    """
    if request.method == 'GET':
        # Get user specifications/ preferences
        user_preference = request.GET['user_preference']
        user_location = request.GET['location']
        fuel_type = request.GET['fuel_type']
        max_radius_km = request.GET['distance']

        user_lat, user_lng = geocoding(user_location)

        # Limit search range, check only for stations that are within user specified radius of the location
        # Convert radius from km to degree [110.574km = 1deg lat/lng]
        max_radius_degree = max_radius_km/110.574 
        # Filter for stations within the radius
        preferences_list = []
        stations_near_me = Station.objects.filter(
            lat__lte=user_lat+max_radius_degree, lat__gte=user_lat-max_radius_degree, lng__lte=user_lng+max_radius_degree, lng__gte=user_lng-max_radius_degree
        )
        # (i) If user has not provide any specification/ preferences, return this:
        preferences_list = stations_near_me

        # (ii) If fuel_type is specified, show only stations that have said fuel.
        if fuel_type:
            fuel_preference = fuel_type+'_price'
            kwargs = {
                '{0}__{1}'.format(fuel_preference, 'isnull'): True,
            }
            # Exclude stations where fuel price is not available
            fuel_prices_all = FuelPrice.objects.filter(station__in=preferences_list).exclude(**kwargs)
            fuel_prices_preference = fuel_prices_all.values_list(fuel_preference, flat=True)
            preferences_list = [fuel_price.station for fuel_price in fuel_prices_all]

        # Get travel durations and distances and store as a dictionary: { station_pk : duration } pair
        # Duration units: seconds   Distance units: km
        travel_durations, travel_distance = dict(), dict()
        for station in preferences_list:
            travel_durations[station.pk], travel_distance[station.pk] = get_duration_distance(user_lat, user_lng, station.lat, station.lng)

        # (iii) If user's optimisation criteria is duration
        if user_preference == 'duration':

            # Sort travel durations. 
            sorted_duration = {k: v for k, v in sorted(travel_durations.items(), key=lambda item: item[1])}
            sorted_station_pks = sorted_duration.keys()

            # Sort stations according to sorted durations, querying stations in the correct order
            preferences_list = query_sorted_order(sorted_station_pks)

        # (iv) If user's optimisation criteria is price
        # Assuming 0.057litre per km x £1.442/litre = £0.082/km distance
        if user_preference == 'price':
            if not fuel_type:
                return JsonResponse({'status':'false', 'message': 'Fuel type not specified.'}, status=500)

            weighted_prices = dict()
            for index, station in enumerate(preferences_list):
                weighted_prices[station.pk] = fuel_prices_preference[index] + Decimal(travel_distance[station.pk]*0.082)
            
            sorted_weighted_prices = {k: v for k, v in sorted(weighted_prices.items(), key=lambda item: item[1])}
            sorted_station_pks = list(sorted_weighted_prices.keys())

            # Sort stations according to sorted durations, querying stations in the correct order
            preferences_list = query_sorted_order(sorted_station_pks[:10])

        # Append prices with the station information
        response = []
        for station in preferences_list:
            station_response = station.serialize()
            station_response['prices'] = FuelPrice.objects.get(station=station.pk).serialize()
            station_response['duration'] = str(int(travel_durations[station.pk]/60)) + 'mins'
            response.append(station_response)

    return JsonResponse(response, safe=False)

# calculate the travel duration to this station
def get_duration_distance(lat1, lng1, lat2, lng2):
    bingMapsKey = "Aiiv3MUtA8Fq3gGOuwLYLrzz_FRSm1xXUEgDZxO6-R8wg73PKwV50hxqwSrbBhXY"
    routeUrl = "http://dev.virtualearth.net/REST/V1/Routes/Driving?wp.0=" + str(lat1) + "," + str(
        lng1) + "&wp.1=" + str(lat2) + "," + str(lng2) + "&key=" + bingMapsKey

    request = urllib.request.Request(routeUrl)
    response = urllib.request.urlopen(request)

    r = response.read().decode(encoding="utf-8")
    result = json.loads(r)
    duration = result['resourceSets'][0]['resources'][0]['routeLegs'][0]['travelDuration'] # units: km
    distance = result['resourceSets'][0]['resources'][0]['routeLegs'][0]['travelDistance'] # units: seconds

    # return the duration and distance
    return duration, distance

def geocoding(location):
    location_iq_key = "pk.bd315221041f3e0a99e6464f9de0157a"
    routeUrl = "https://eu1.locationiq.com/v1/search.php?key=" + location_iq_key + "&q=" + str(location.replace(' ','%20')) + "&format=json"

    request = urllib.request.Request(routeUrl)
    response = urllib.request.urlopen(request)

    r = response.read().decode(encoding="utf-8")
    result = json.loads(r)

    return float(result[0]['lat']), float(result[0]['lon'])

def query_sorted_order(pk_list):
    """ Query stations in sorted order and append into a list. """
    preferences_list = []
    for pk in pk_list:
        preferences_list.append(Station.objects.get(pk=pk))
    
    return preferences_list