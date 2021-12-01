from django.http.response import HttpResponse
from django.shortcuts import render,redirect
from stations.models import FuelPrice, Station, UserReview
from rest_framework import generics
from rest_framework.decorators import api_view,permission_classes

from django.contrib import messages
import pandas as pd
import time
import math
import urllib.request
import json
import boto3
from django.db import connection
from django.http import JsonResponse
from decimal import Decimal
# Create your views here.
from stations import models
from .serializers import StationSerializer

from rest_framework.permissions import IsAuthenticated,AllowAny

class ListStation(generics.ListCreateAPIView):
    permission_classes = (IsAuthenticated,)
    queryset = models.Station.objects.all() 
    serializer_class = StationSerializer

class DetailStation(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Station.objects.all()
    serializer_class = StationSerializer


def detailStation(request, station_id):
    """Returns information regarding a specific station."""
    if request.method == 'GET':
        station = Station.objects.get(station_id=station_id)
        prices = FuelPrice.objects.get(station=station.station_id)

        response = station.serialize()
        response['prices'] = prices.serialize()
    
    return JsonResponse(response, safe=False)

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

@api_view()
@permission_classes([AllowAny])
def home(request):
    """
    home API returns the client a json list of all petrol stations visible within a user's viewport when the 
    app is first opened (homepage).
    API called via a GET Request.
    Example API call: http://127.0.0.1:8000/apis/home/?lat_max=51.5&lat_min=51.4&lng_max=-0.06&lng_min=-0.09
    """

    #permission_classes = (IsAuthenticated,) #Uncomment this later

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

        response = []
        for station in stations_near_me:
            station_response = station.serialize()
            station_response['prices'] = FuelPrice.objects.get(station=station.pk).serialize()
            response.append(station_response)
    
    # returns a Json list of stations within that page
    return JsonResponse(response, safe=False)

def search(request):
    """
    nearestStation API returns the client a json list of all the petrol stations nearest to the user-specified location
    according to user preference selection.
    API called via a GET Request.
    Example API call: http://127.0.0.1:8000/apis/search/?user_preference=time&location=Imperial%20College%20London&fuel_type=unleaded&distance=50&amenities=
    """
    if request.method == 'GET':
        # Get user specifications/ preferences
        user_preference = request.GET['user_preference']
        user_location = request.GET['location']
        fuel_type = request.GET['fuel_type']
        max_radius_km = request.GET['distance']
        amenities_list = request.GET['amenities'].split(',')

        user_lat, user_lng = geocoding(user_location)

        # Default distance range
        if max_radius_km == '':
            max_radius_km = 30

        # (i) Distance Limit: check only for stations that are within user specified radius of the location
        # Convert radius from km to degree [110.574km = 1deg lat/lng]
        max_radius_degree = float(max_radius_km)/110.574
        # Filter for stations within the radius
        """
        preferences_list = Station.objects.filter(
            lat__lte=user_lat+max_radius_degree,
            lat__gte=user_lat-max_radius_degree,
            lng__lte=user_lng+max_radius_degree, 
            lng__gte=user_lng-max_radius_degree
        )
        """
        preferences_list = FuelPrice.objects.filter(
            station__lat__lte=user_lat+max_radius_degree,
            station__lat__gte=user_lat-max_radius_degree,
            station__lng__lte=user_lng+max_radius_degree,
            station__lng__gte=user_lng-max_radius_degree
        )
        
        # If user has not provide any specification/ preferences, return this:
        # preferences_list = stations_prices_near_me

        # (ii) If fuel_type is specified, show only stations that have said fuel.
        if fuel_type:
            fuel_preference = fuel_type+'_price'
            kwargs = {
                '{0}__{1}'.format(fuel_preference, 'isnull'): True,
            }
            
            # Exclude stations where fuel price is not available
            preferences_list = preferences_list.exclude(**kwargs)
            # preferences_list = [fuel_price.station for fuel_price in fuel_prices_all]

        # (iii) Filter all the amenities (if any). If the station doesn't have the amenity listed, exclude.
        if amenities_list!=['']:
            for amenity in amenities_list:
                station__amenity = 'station__'+amenity
                kwargs = {}
                kwargs['{0}__{1}'.format(station__amenity, 'exact')] = 0
                preferences_list = preferences_list.exclude(**kwargs)

        # (iv) Get travel durations and distances for current candidates and store as a dictionary: { station_pk : duration } pair
        # Duration units: seconds   Distance units: km
        carbon_emission, travel_distance, travel_traffic_durations = dict(), dict(), dict(), dict()
        emission_factor=0.2 #kgCO2/km
        for fuel_price in preferences_list:
            travel_traffic_durations[fuel_price.station.pk], travel_distance[fuel_price.station.pk] = get_duration_distance(user_lat, user_lng, fuel_price.station.lat, fuel_price.station.lng)
            try:
                congestion = UserReview.objects.get(station=fuel_price.station.pk).congestion
            except UserReview.DoesNotExist:
                congestion = 0
            travel_traffic_durations[fuel_price.station.pk] += congestion
            carbon_emission[fuel_price.station.pk] = emission_factor*travel_distance[fuel_price.station.pk]
            
        # (v) Optimisation Criteria. If
        # a. Time to arrivals
        if user_preference == 'time':
            # Sort travel durations. 
            sorted_duration = {k: v for k, v in sorted(travel_traffic_durations.items(), key=lambda item: item[1])}
            sorted_station_pks = sorted_duration.keys()

            # Query stations in sorted order
            preferences_list = query_sorted_order(sorted_station_pks)
            # API Response
            response = create_response(preferences_list,travel_traffic_durations,travel_distance,carbon_emission)

        # b. Carbon Footprint
        if user_preference == 'eco':
            # Sort carbon emissions
            sorted_eco = {k: v for k, v in sorted(carbon_emission.items(), key=lambda item: item[1])}
            sorted_station_pks = sorted_eco.keys()

            # Query stations in sorted order
            preferences_list = query_sorted_order(sorted_station_pks)
            # API Response
            response = create_response(preferences_list,travel_traffic_durations,travel_distance,carbon_emission)

        # c. Fuel Price
        # Assuming average speed = 50miles/hr = 80.47km/hr; 0.057litre per km;  £1.442/litre 
        # Penalty cost for duration = £0.00184/s
        # Penalty cost for distance = £0.0822/km

        if user_preference == 'price' or user_preference == '':
            if not fuel_type:
                fuel_preference = ['unleaded_price','diesel_price','super_unleaded_price','premium_diesel_price']
                best_station_general = {} 
                kwargs = {}
                tmp = preferences_list
                for pref in fuel_preference:
                    kwargs = {
                        '{0}__{1}'.format(pref, 'isnull'): True,
                    }
                    curr_pref_list = tmp
                    curr_pref_list = curr_pref_list.exclude(**kwargs)
                    preferred_fuel_prices = curr_pref_list.values_list(pref, flat=True)
                    # Sort stations according to sorted durations
                    sorted_station_pks = sort_by_price(curr_pref_list, travel_traffic_durations, travel_distance, preferred_fuel_prices)
                    # Query stations in sorted order, selecting only the top 3 station for each fuel type
                    curr_pref_list = query_sorted_order(sorted_station_pks[:3]) 
                    best_station_general[pref]=curr_pref_list

                response = []
                for fuel, preferences_list in best_station_general.items():
                    fuel_response={}
                    fuel_response['fuel_type']=fuel
                    # top_3=[]
                    # for fuel_price in preferences_list:
                    #     station_response = fuel_price.station.serialize()
                    #     station_response['prices'] = fuel_price.serialize()
                    #     station_response['duration'] = str(int(travel_traffic_durations[fuel_price.station.pk]/60)) + 'mins'
                    #     station_response['distance'] = str(travel_distance[fuel_price.station.pk]) + 'km'
                    #     top_3.append(station_response)
                    fuel_response['Top 3 Stations']=create_response(preferences_list,travel_traffic_durations,travel_distance,carbon_emission)
                    response.append(fuel_response)

            else:
                preferred_fuel_prices = preferences_list.values_list(fuel_preference, flat=True)
                # Sort stations according to sorted durations
                sorted_station_pks = sort_by_price(preferences_list, travel_traffic_durations, travel_distance, preferred_fuel_prices)
                # Query stations in sorted order
                preferences_list = query_sorted_order(sorted_station_pks[:10])
                # API Response
                response = create_response(preferences_list,travel_traffic_durations,travel_distance,carbon_emission)
                

    return JsonResponse(response, safe=False)

@api_view(['POST'])
def review(request):
    """API handles all user requests regarding station reviews."""
    if request.method == 'POST':
        if 'receipt' in request.FILES:
            receipt = request.FILES['receipt']
            s3 = boto3.client(
                's3',
                aws_access_key_id="AKIA4O5FKY2EUZ3SY7P4",
                aws_secret_access_key="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",
            )
            s3.upload_fileobj(receipt, "fuelopt-s3-main", receipt.name)
            # create new review
            return JsonResponse({'status':'true', 'message': 'Good.'}, status=200)
        else:
            station_id = request.POST['station'] # pk?
            open_status = not bool(int(request.POST['close'])) # Boolean
            unleaded_price = float(request.POST['unleaded_price']) # Decimal
            diesel_price = float(request.POST['diesel_price']) # Decimal
            super_unleaded_price = float(request.POST['super_unleaded_price']) # Decimal
            premium_diesel_price = float(request.POST['premium_diesel_price']) # Decimal
            congestion = int(request.POST['congestion']) # Integer

            # anomaly detection

            station = Station.objects.get(pk=station_id)

            # update fuel prices
            fuel_prices = FuelPrice.objects.get(station=station)
            fuel_prices.unleaded_price = unleaded_price if (unleaded_price is not None) else fuel_prices.unleaded_price
            fuel_prices.diesel_price = diesel_price if (diesel_price is not None) else fuel_prices.diesel_price
            fuel_prices.super_unleaded_price = super_unleaded_price if (super_unleaded_price is not None) else fuel_prices.super_unleaded_price
            fuel_prices.premium_diesel_price = premium_diesel_price if (premium_diesel_price is not None) else fuel_prices.premium_diesel_price
            fuel_prices.save()
            
            # update or create user review
            user_review = UserReview.objects.get(station=station)
            if user_review:
                user_review.unleaded_price = unleaded_price if (unleaded_price is not None) else user_review.unleaded_price
                user_review.diesel_price = diesel_price if (diesel_price is not None) else user_review.diesel_price
                user_review.super_unleaded_price = super_unleaded_price if (super_unleaded_price is not None) else user_review.super_unleaded_price
                user_review.premium_diesel_price = premium_diesel_price if (premium_diesel_price is not None) else user_review.premium_diesel_price
                user_review.open_status = open_status
                user_review.congestion = congestion
                user_review.save()
            else:
                new_review = UserReview(station=station, 
                                        unleaded_price = unleaded_price,
                                        diesel_price = diesel_price,
                                        super_unleaded_price = super_unleaded_price,
                                        premium_diesel_price = premium_diesel_price,
                                        opening=open_status, 
                                        congestion=congestion)
                new_review.save()
            return JsonResponse({'status':'true', 'message': 'Good.'}, status=200)

# calculate the travel duration to this station
def get_duration_distance(lat1, lng1, lat2, lng2):
    bingMapsKey = "Aiiv3MUtA8Fq3gGOuwLYLrzz_FRSm1xXUEgDZxO6-R8wg73PKwV50hxqwSrbBhXY"
    routeUrl = "http://dev.virtualearth.net/REST/V1/Routes/Driving?wp.0=" + str(lat1) + "," + str(
        lng1) + "&wp.1=" + str(lat2) + "," + str(lng2) + "&key=" + bingMapsKey
    # http://dev.virtualearth.net/REST/V1/Routes/Driving?wp.0=51.0,-0.1,&wp.1=51.5,-0.12&key=Aiiv3MUtA8Fq3gGOuwLYLrzz_FRSm1xXUEgDZxO6-R8wg73PKwV50hxqwSrbBhXY
    request = urllib.request.Request(routeUrl)
    response = urllib.request.urlopen(request)

    r = response.read().decode(encoding="utf-8")
    result = json.loads(r)
    duration_with_traffic = result['resourceSets'][0]['resources'][0]['travelDurationTraffic'] # units: s
    distance = result['resourceSets'][0]['resources'][0]['travelDistance'] # units: km

    # return the duration and distance
    return duration_with_traffic, distance

def sort_by_price(preferences_list, travel_traffic_durations, travel_distance, preferred_fuel_prices):
    """
    preferences_list(query object): list of potential station candidates
    """
    weighted_prices = dict()
    for index, fuel_price in enumerate(preferences_list):
        weighted_prices[fuel_price.station.pk] = \
            preferred_fuel_prices[index] + \
            Decimal(travel_traffic_durations[fuel_price.station.pk]*0.00184) + \
            Decimal(travel_distance[fuel_price.station.pk]*0.0822)

    sorted_weighted_prices = {k: v for k, v in sorted(weighted_prices.items(), key=lambda item: item[1])}
    sorted_station_pks = list(sorted_weighted_prices.keys())

    return sorted_station_pks

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
        preferences_list.append(FuelPrice.objects.get(station_id=pk))
    
    return preferences_list


def create_response(preferences_list,travel_traffic_durations,travel_distance,carbon_emission):
    response = []
    for fuel_price in preferences_list:
        station_response = fuel_price.station.serialize()
        station_response['prices'] = fuel_price.serialize()
        station_response['duration'] = str(int(travel_traffic_durations[fuel_price.station.pk]/60)) + 'mins'
        station_response['distance'] = str(travel_distance[fuel_price.station.pk]) + 'km'
        station_response['emission'] = str(round(carbon_emission[fuel_price.station.pk],2)) + 'kgCO2'
        response.append(station_response)
    
    return response

