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
    # When user opens app, show locations
    if request.method == 'GET':
        # Get the bounding box, sent via query string issued by flutter
        # eg url to call: http://127.0.0.1:8000/apis/home/?lat_max=51.5&lat_min=51.4&lng_max=-0.06&lng_min=-0.09
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
    if request.method == 'GET':
        user_preference = request.GET['user_preference']
        user_lat = float(request.GET['lat'])
        user_lng = float(request.GET['lng'])
        fuel_type = request.GET['fuel_type']

        # Limit search range, check distances only for stations that:
        # (i)  are within ~5km radius of the location
        # (ii) have the available fuel type
        preferences_list = []
        stations_near_me = Station.objects.filter(
            lat__lte=user_lat+0.1, lat__gte=user_lat-0.1, lng__lte=user_lng+0.1, lng__gte=user_lng-0.1
        )
        preferences_list = stations_near_me

        # if fuel_type is specified filter stations that has that type of fuel
        if fuel_type:
            fuel_preference = fuel_type+'_price'
            kwargs = {
                '{0}__{1}'.format(fuel_preference, 'isnull'): True,
            }
            fuel_prices = FuelPrice.objects.filter(station__in=preferences_list).exclude(**kwargs)
            preferences_list = [fuel_price.station for fuel_price in fuel_prices]

        if user_preference == 'duration':
            # get travel duration and store in { station_pk : duration } pair
            travel_durations = {}
            for station in preferences_list:
                travel_durations[station.pk] = get_travel_duration(user_lat, user_lng, station.lat, station.lng)

            # sort by duration and query station in the correct order
            sorted_duration = {k: v for k, v in sorted(travel_durations.items(), key=lambda item: item[1])}
            sorted_station_pks = sorted_duration.keys()

            preferences_list = []
            for pk in list(sorted_station_pks)[:10]:
                preferences_list.append(Station.objects.get(pk=pk))

        response = []
        for station in preferences_list:
            station_response = station.serialize()
            station_response['prices'] = FuelPrice.objects.get(station=station.pk).serialize()
            response.append(station_response)

    return JsonResponse(response, safe=False)

# calculate the travel distance to this station
def get_travel_duration(lat1, lng1, lat2, lng2):
    bingMapsKey = "Aiiv3MUtA8Fq3gGOuwLYLrzz_FRSm1xXUEgDZxO6-R8wg73PKwV50hxqwSrbBhXY"
    routeUrl = "http://dev.virtualearth.net/REST/V1/Routes/Driving?wp.0=" + str(lat1) + "," + str(
        lng1) + "&wp.1=" + str(lat2) + "," + str(lng2) + "&key=" + bingMapsKey

    request = urllib.request.Request(routeUrl)
    response = urllib.request.urlopen(request)

    r = response.read().decode(encoding="utf-8")
    result = json.loads(r)
    duration = result['resourceSets'][0]['resources'][0]['routeLegs'][0]['travelDuration']
    # return the duration
    return duration
