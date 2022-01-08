import pandas as pd
import time
import math
import boto3
import requests
import pandas as pd

from stations.models import FuelPrice, Station, UserReview
from rest_framework import generics
from rest_framework.decorators import api_view, permission_classes
from django.contrib import messages
from django.db import connection
from django.http import JsonResponse
from django.conf import settings
from django.shortcuts import render, redirect
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.parsers import MultiPartParser
from rest_framework.decorators import parser_classes
from stations import models
from .serializers import StationSerializer, StationDetailSerializer1, StationDetailSerializer2, StationDetailSerializer3, UserReviewSerializer, SearchInputSerializer, HomeSerializer
from .utils import geocoding_with_postcode, geocoding_with_name, get_duration_distance, sort_by_price, \
    query_sorted_order, create_response, check_and_update, read_receipt
from .config import AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi


class ListStation(generics.ListAPIView):
    """
    Return a list of all petrol stations in the database.
    """
    permission_classes = (IsAuthenticated,)
    queryset = models.Station.objects.all()
    serializer_class = StationSerializer


class DetailStation(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Station.objects.all()
    serializer_class = StationSerializer

@swagger_auto_schema(method='get', operation_summary="Get Detailed Station Info", responses={200: StationDetailSerializer3()})
@api_view(['GET'])
@permission_classes([AllowAny])
def detailStation(request, station_id):
    """Returns information regarding a specific station."""
    if request.method == 'GET':
        station = Station.objects.get(station_id=station_id)
        prices = FuelPrice.objects.get(station=station.station_id)
        try:
            user_review = UserReview.objects.get(station=station.station_id)
        except UserReview.DoesNotExist:
            user_review = None

        response = station.serialize()
        response['prices'] = prices.serialize()
        if user_review:
            response['user_review'] = user_review.serialize()

    return JsonResponse(response, safe=False)


def temp_admin(request):
    if request.method == 'POST':
        # Handle login
        if 'restartEntries' in request.POST:
            messages.success(request, 'Stations Database Restarted (and fuel prices updated)')
            restartStationEntries()
            updateEntries()
            return redirect('apis:temp_admin')
        if 'updateEntries' in request.POST:
            messages.success(request, 'Fuel Prices Updated')
            updateEntries()
            return redirect('apis:temp_admin')
        if 'deleteFuelPrices' in request.POST:
            messages.success(request, 'Fuel Prices Deleted')
            deleteFuelPrices()
            return redirect('apis:temp_admin')

    return render(request, 'apis/temp_admin.html')


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
        print("\t", index, "/ 777")

        station = Station(name=row["name"].strip(), street=row["street"].strip(), postcode=row["postcode"].strip(),
                          lat=row["lat"], lng=row["lng"], station_ref=row["station_id"])
        station.save()

        # add a second delay to not overwhelm the database
        if index % 200 == 0:
            time.sleep(1)

    print("Done inserting station information to database.")
    return


def updateEntries():
    data = pd.read_csv('../data/db_scripts/stations_all_info.csv')

    print("Updating fuel prices information to database:")
    for index, row in data.iterrows():
        print("\t", index, "/ 777")
        station = Station.objects.filter(station_ref=row["station_id"]).first()

        unleaded = None
        diesel = None
        super_unleaded = None
        premium_diesel = None
        if not math.isnan(row["unleaded"]):
            unleaded = row["unleaded"]
        if not math.isnan(row["diesel"]):
            diesel = row["diesel"]
        if not math.isnan(row["super_unleaded"]):
            super_unleaded = row["super_unleaded"]
        if not math.isnan(row["premium_diesel"]):
            premium_diesel = row["premium_diesel"]

        fuelPrice = FuelPrice(station=station, unleaded_price=unleaded, diesel_price=diesel,
                              super_unleaded_price=super_unleaded, premium_diesel_price=premium_diesel)
        fuelPrice.save()

        # add a second delay to not overwhelm the database
        if index % 200 == 0:
            time.sleep(1)
    print("Done updating fuel information to database.")

    return

def deleteFuelPrices():
    FuelPrice.objects.all().delete()

@swagger_auto_schema(method='get', query_serializer=HomeSerializer, operation_summary="List stations in a certain area", responses={200: StationDetailSerializer1()})
@api_view()
@permission_classes([AllowAny])
def home(request):
    """
    home API (GET Request) returns the client a json list of all petrol stations visible within a user's viewport when the app is first opened (homepage).
    The bounds of the viewport are given by the following query parameters:
    Query Parameters: 
    - lat_max: maximum latitude
    - lat_min: minimum latititude
    - lng_max: maximum longitude
    - lng_min: minimum longitude
    """
    # permission_classes = (IsAuthenticated,) #Uncomment this later

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

@swagger_auto_schema(method='get', query_serializer=SearchInputSerializer, operation_summary="Search and Sort Stations", responses={200: StationDetailSerializer2(), 500: 'Internal Server Error'})
@api_view(['GET'])
@permission_classes([AllowAny])
def search(request):
    """
    search API (GET Request) returns the client a json list of all the petrol stations nearest to the user-specified location.
    Users can specify the following query parameters to personalise their search results:
    - user_preference: The method of optimisation
        - time
        - price
        - eco-friendliness
    - location: The address where the user wants to execute the search. This is used if 'lat' and 'lng' are empty.
    - lat: The latitude of the search location. This takes precedence over 'location'.
    - lng: The longitude of the search location. This takes precedence over 'location'.
    - fuel type:
        - unleaded
        - super unleaded
        - diesel
        - premium diesel
    - distance: The search radius where the search results should fall within. Max distance is limited to 15km.
    - amenities: Choose from 16 different amenities that the user would like suggested results to have
    """
    if request.method == 'GET':
        # user preference
        if 'user_preference' in request.GET:
            user_preference = request.GET['user_preference']
        else:
            user_preference = ""

        # user location
        if 'location' in request.GET:
            user_location = request.GET['location']
        else:
            user_location = ""

        # fuel type
        if 'fuel_type' in request.GET:
            fuel_type = request.GET['fuel_type']
        else:
            fuel_type = ""

        # search radius
        if 'distance' in request.GET and request.GET['distance']!='':
                max_radius_km = int(float(request.GET['distance']))
        else:
            max_radius_km = 5

        # amenities
        if 'amenities' in request.GET:
            amenities_list = request.GET['amenities'].split(',')
        else:
            amenities_list = [""]
        # Geocoding - convert addresses into coordinates for processing
        if 'lat' in request.GET and request.GET['lat'] != '':
            user_lat = float(request.GET['lat'])
            user_lng = float(request.GET['lng'])
        else:
            user_lat = ""
            user_lng = ""

        if not user_lat and not user_lng:
            try:
                user_lat, user_lng = geocoding_with_postcode(user_location)
            except ValueError as e:
                try:
                    user_lat, user_lng = geocoding_with_name(user_location)
                except ValueError as e:
                    return JsonResponse({ 'status':'false', 'message': str(e) }, status=500)

        if max_radius_km > 15:
            return JsonResponse({'status':'false', 'message': 'Max search radius of 15km exceeded. Please use a distance of 15km or less.'}, status=500)

        # (i) Distance Limit: check only for stations that are within user specified radius of the location
        # Convert radius from km to degree [110.574km = 1deg lat/lng]
        max_radius_degree = float(max_radius_km) / 110.574
        # Filter for stations within the radius
        preferences_list = FuelPrice.objects.filter(
                station__lat__lte=user_lat + max_radius_degree,
                station__lat__gte=user_lat - max_radius_degree,
                station__lng__lte=user_lng + max_radius_degree,
                station__lng__gte=user_lng - max_radius_degree
            )

        if preferences_list.count() == 0:
            return JsonResponse({'status': 'false', 'message': 'Location not in range. Please select location within the London region.'}, status=500)

        # (ii) Opening Hours: remove stations that are not open from preferences_list
        closed_station = []
        for fuel_price in preferences_list:
            try:
                opening = UserReview.objects.get(station=fuel_price.station).opening
            except UserReview.DoesNotExist:
                opening = True

            if not opening:
                closed_station.append(fuel_price.id)
        preferences_list = preferences_list.exclude(id__in=closed_station)

        # (iii) Fuel Type: show only stations that have the preferred fuel (if specified)
        if fuel_type:
            fuel_preference = fuel_type + '_price'
            kwargs = {
                '{0}__{1}'.format(fuel_preference, 'isnull'): True,
            }

            # Exclude stations where fuel price is not available
            preferences_list = preferences_list.exclude(**kwargs)

        # (iv) Amenities: show only stations with preferred amenities (if specified)
        if amenities_list != ['']:
            for amenity in amenities_list:
                station__amenity = 'station__' + amenity
                kwargs = {'{0}__{1}'.format(station__amenity, 'exact'): 0}
                preferences_list = preferences_list.exclude(**kwargs)

        # Get carbon emissions, travel durations and distances for current candidates and store as a dictionary: EG { station_pk : duration } pair
        # Carbon Emission units: kgCO2/km   Duration units: seconds   Distance units: km
        carbon_emission, travel_distance, travel_traffic_durations, travel_duration = dict(), dict(), dict(), dict()
        emission_factor = 0.2  # kgCO2/km
        bing_key = 'a'
        s = requests.Session()

        for index, fuel_price in enumerate(preferences_list):
            if index % 5:
                if bing_key == 'a':
                    bing_key = 'b'
                else:
                    bing_key = 'a'

            travel_traffic_durations[fuel_price.station.pk], travel_duration[fuel_price.station.pk], travel_distance[
                fuel_price.station.pk] = get_duration_distance(user_lat, user_lng, fuel_price.station.lat,
                                                               fuel_price.station.lng, bing_key, s)
            try:
                congestion = UserReview.objects.get(station=fuel_price.station).congestion
            # Include congestion time specified by User Reviews
            except UserReview.DoesNotExist:
                congestion = 0
            travel_traffic_durations[fuel_price.station.pk] = travel_traffic_durations[
                                                                  fuel_price.station.pk] + congestion
            carbon_emission[fuel_price.station.pk] = emission_factor * travel_distance[fuel_price.station.pk]

        # (v) Optimisation Criteria.
        # a. Time to arrivals
        if user_preference == 'time':
            # Sort travel durations. 
            sorted_duration = {k: v for k, v in sorted(travel_traffic_durations.items(), key=lambda item: item[1])}
            sorted_station_pks = sorted_duration.keys()

            # Query stations in sorted order
            preferences_list = query_sorted_order(sorted_station_pks)
            # API Response
            response = create_response(preferences_list, travel_traffic_durations, travel_distance, carbon_emission)

        # b. Carbon Footprint
        if user_preference == 'eco':
            # Sort carbon emissions
            sorted_eco = {k: v for k, v in sorted(carbon_emission.items(), key=lambda item: item[1])}
            sorted_station_pks = sorted_eco.keys()

            # Query stations in sorted order
            preferences_list = query_sorted_order(sorted_station_pks)
            # API Response
            response = create_response(preferences_list, travel_traffic_durations, travel_distance, carbon_emission)

        # c. Fuel Price
        if user_preference == 'price' or user_preference == '':
            # Generic Search
            if not fuel_type:
                fuel_preference = ['unleaded_price', 'diesel_price', 'super_unleaded_price', 'premium_diesel_price']
                best_station_general = {}
                kwargs = {}
                tmp = preferences_list
                for pref in fuel_preference:
                    kwargs = {
                        '{0}__{1}'.format(pref, 'isnull'): True,
                    }
                    curr_pref_list = tmp
                    curr_pref_list = curr_pref_list.exclude(**kwargs)  # type: query
                    preferred_fuel_prices = curr_pref_list.values_list(pref,
                                                                       flat=True)  # type: dictionary {id: fuel price}

                    # Sort stations according to sorted durations
                    sorted_station_pks = sort_by_price(curr_pref_list, travel_traffic_durations, travel_duration,
                                                       travel_distance, preferred_fuel_prices)
                    # Query stations in sorted order, selecting only the top 3 station for each fuel type
                    curr_pref_list = query_sorted_order(sorted_station_pks[:3])
                    best_station_general[pref] = curr_pref_list

                # API Response
                response = []
                for fuel, preferences_list in best_station_general.items():
                    fuel_response = {'fuel_type': fuel,
                                     'Top 3 Stations': create_response(preferences_list, travel_traffic_durations,
                                                                       travel_distance, carbon_emission)}
                    response.append(fuel_response)

            # Fuel Specific Search
            else:
                preferred_fuel_prices = preferences_list.values_list(fuel_preference, flat=True)
                # Sort stations according to sorted durations
                sorted_station_pks = sort_by_price(preferences_list, travel_traffic_durations, travel_duration,
                                                   travel_distance, preferred_fuel_prices)
                # Query stations in sorted order
                preferences_list = query_sorted_order(sorted_station_pks[:10])
                # API Response
                response = create_response(preferences_list, travel_traffic_durations, travel_distance, carbon_emission)

    return JsonResponse(response, safe=False, status=200)

@swagger_auto_schema(method='post', request_body=UserReviewSerializer, operation_summary="Submit Station Review", responses={200: 'Review submitted', 500: 'Internal Server Error', 555: 'Price exceeded threshold'})
@api_view(['POST'])
@parser_classes([MultiPartParser])
def review(request):
    """
    review API is used to update station information (fuel prices, congestion times and opening times) based on user reviews.
    Query Parameters:
    - station_id: the station's information to be updated
    - unleaded_price : price for unleaded fuel
    - diesel_price : price for diesel fuel
    - super_unleaded_price : price for super unleaded fuel
    - premium_diesel_price : price for premium diesel price fuel
    - open: 1 if the station is open, 0 otherwise
    - congestion: the time spent waiting/ queing at the station
    - receipt: an image of the receipt. This is only required if a 500 status code is obtained, indicating input prices have exceeded thresholds
    """
    if request.method == 'POST':
        station_id = request.POST['station']  
        station = Station.objects.get(pk=station_id)
        fuel_prices = FuelPrice.objects.get(station=station)
        user_review, _ = UserReview.objects.get_or_create(station=station)

        if 'receipt' in request.FILES:
            try:
                receipt = request.FILES['receipt']
                s3 = boto3.client(
                    's3',
                    aws_access_key_id=AWS_ACCESS_KEY_ID[0],
                    aws_secret_access_key=AWS_SECRET_ACCESS_KEY
                )
                s3.upload_fileobj(receipt, "fuelopt-s3-main", receipt.name)

                if settings.TESTING:
                    receipt_path = "static/reviews/" + receipt.name
                else:
                    receipt_path = "backend/static/reviews/" + receipt.name
                s3.download_file("fuelopt-s3-main", receipt.name, receipt_path)
                price, type_of_fuel, date = read_receipt(receipt_path)

                setattr(fuel_prices, type_of_fuel + "_price", str(price))
                setattr(user_review, type_of_fuel + "_price", str(price))
                fuel_prices.save()
                user_review.save()
                # create new review
                return JsonResponse({'status': 'true', 'message': 'Receipt submitted'}, status=200)
            except Exception as e:
                return JsonResponse({'status': 'false', 'message': str(e)}, status=500)
        else:
            if request.POST['open'] != "":
                user_review.opening = bool(int(request.POST['open']))

            if request.POST['congestion'] != "":
                user_review.congestion = int(request.POST['congestion'])

            user_review.save()

            if ('unleaded_price' in request.POST) and request.POST['unleaded_price'] != "":
                unleaded_price = float(request.POST['unleaded_price'])  # Decimal
                if not check_and_update('unleaded_price', unleaded_price, fuel_prices, user_review):
                    return JsonResponse({'status': 'false', 'message': 'Exceeded threshold. Please submit receipt.'},
                                        status=555)

            if ('diesel_price' in request.POST) and request.POST['diesel_price'] != "":
                diesel_price = float(request.POST['diesel_price'])  # Decimal
                if not check_and_update('diesel_price', diesel_price, fuel_prices, user_review):
                    return JsonResponse({'status': 'false', 'message': 'Exceeded threshold. Please submit receipt.'},
                                        status=555)

            if ('super_unleaded_price' in request.POST) and request.POST['super_unleaded_price'] != "":
                super_unleaded_price = float(request.POST['super_unleaded_price'])  # Decimal
                if not check_and_update('super_unleaded_price', super_unleaded_price, fuel_prices, user_review):
                    return JsonResponse({'status': 'false', 'message': 'Exceeded threshold. Please submit receipt.'},
                                        status=555)

            if ('premium_diesel_price' in request.POST) and request.POST['premium_diesel_price'] != "":
                premium_diesel_price = float(request.POST['premium_diesel_price'])  # Decimal
                if not check_and_update('premium_diesel_price', premium_diesel_price, fuel_prices, user_review):
                    return JsonResponse({'status': 'false', 'message': 'Exceeded threshold. Please submit receipt.'},
                                        status=555)

            fuel_prices.save()
            user_review.save()
            return JsonResponse({'status': 'true', 'message': 'Good.'}, status=200)
