import pandas as pd
import time
import math
import boto3
import requests
from stations.models import FuelPrice, Station, UserReview
from rest_framework import generics
from rest_framework.decorators import api_view, permission_classes
from django.contrib import messages
from django.db import connection
from django.http import JsonResponse
from django.conf import settings
from django.shortcuts import render, redirect
from rest_framework.permissions import IsAuthenticated, AllowAny
from stations import models
from .serializers import StationSerializer
from .utils import geocoding_with_postcode, geocoding_with_name, get_duration_distance, sort_by_price, query_sorted_order, create_response, check_and_update, read_receipt

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
        if ('restartEntries') in request.POST:
            messages.success(request, 'Stations Database Restarted (and fuel prices updated)')
            restartStationEntries()
            updateEntries()
            return redirect('apis:temp_admin')
        if ('updateEntries') in request.POST:
            messages.success(request, 'Fuel Prices Updated')
            updateEntries()
            return redirect('apis:temp_admin')
        if ('deleteFuelPrices') in request.POST:
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
        if (index % 200 == 0):
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
        if (not math.isnan(row["unleaded"])):
            unleaded = row["unleaded"]
        if (not math.isnan(row["diesel"])):
            diesel = row["diesel"]
        if (not math.isnan(row["super_unleaded"])):
            super_unleaded = row["super_unleaded"]
        if (not math.isnan(row["premium_diesel"])):
            premium_diesel = row["premium_diesel"]

        fuelPrice = FuelPrice(station=station, unleaded_price=unleaded, diesel_price=diesel,
                              super_unleaded_price=super_unleaded, premium_diesel_price=premium_diesel)
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
    Example API call: http://18.170.63.134:8000/apis/home/?lat_max=51.5&lat_min=51.4&lng_max=-0.06&lng_min=-0.09
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


def search(request):
    """
    nearestStation API returns the client a json list of all the petrol stations nearest to the user-specified location
    according to user preference selection.
    API called via a GET Request.
    Example API call: http://18.170.63.134:8000/apis/search/?user_preference=time&location=Imperial%20College%20London&fuel_type=unleaded&distance=30&amenities=
    """
    if request.method == 'GET':
        # Get user specifications/ preferences
        user_preference = request.GET['user_preference']
        user_location = request.GET['location']
        fuel_type = request.GET['fuel_type']
        max_radius_km = request.GET['distance']
        amenities_list = request.GET['amenities'].split(',')

        try:
            user_lat, user_lng = geocoding_with_postcode(user_location)
        except ValueError as e:
            try:
                user_lat, user_lng = geocoding_with_name(user_location)
            except ValueError as e:
                return JsonResponse({ 'status':'false', 'message': str(e) }, status=500)

        # Default distance range
        if max_radius_km == '':
            max_radius_km = 10

        # (i) Distance Limit: check only for stations that are within user specified radius of the location
        # Convert radius from km to degree [110.574km = 1deg lat/lng]
        max_radius_degree = float(max_radius_km)/110.574
        # Filter for stations within the radius
        try:
            preferences_list = FuelPrice.objects.filter(
                station__lat__lte=user_lat + max_radius_degree,
                station__lat__gte=user_lat - max_radius_degree,
                station__lng__lte=user_lng + max_radius_degree,
                station__lng__gte=user_lng - max_radius_degree
            )
        # If outside area of coverage (London)
        except FuelPrice.DoesNotExist:
            return JsonResponse({ 'status':'false', 'message': 'Location not in range!' }, status=500)

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

        # (iv) Ammenities: show only stations with preferred amenities (if specified)
        if amenities_list != ['']:
            for amenity in amenities_list:
                station__amenity = 'station__' + amenity
                kwargs = {}
                kwargs['{0}__{1}'.format(station__amenity, 'exact')] = 0
                preferences_list = preferences_list.exclude(**kwargs)

        # Get carbon emissions, travel durations and distances for current candidates and store as a dictionary: EG { station_pk : duration } pair
        # Carbon Emission units: kgCO2/km   Duration units: seconds   Distance units: km
        carbon_emission, travel_distance, travel_traffic_durations, travel_duration = dict(), dict(), dict(), dict()
        emission_factor=0.2 #kgCO2/km
        bing_key = 'a'
        s = requests.Session()

        for index, fuel_price in enumerate(preferences_list):
            if index%5:
                if bing_key == 'a':
                    bing_key = 'b'
                else:
                    bing_key = 'a'
            
            travel_traffic_durations[fuel_price.station.pk], travel_duration[fuel_price.station.pk], travel_distance[fuel_price.station.pk] = get_duration_distance(user_lat, user_lng, fuel_price.station.lat, fuel_price.station.lng, bing_key, s)
            try:
                congestion = UserReview.objects.get(station=fuel_price.station).congestion
            # Include congestion time specified by User Reviews
            except UserReview.DoesNotExist:
                congestion = 0
            travel_traffic_durations[fuel_price.station.pk] = travel_traffic_durations[fuel_price.station.pk]+congestion
            carbon_emission[fuel_price.station.pk] = emission_factor*travel_distance[fuel_price.station.pk]
            
        # (v) Optimisation Criteria.
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
                    curr_pref_list = curr_pref_list.exclude(**kwargs) # type: query
                    preferred_fuel_prices = curr_pref_list.values_list(pref, flat=True) # type: dictionary {id: fuel price}
                    
                    # Sort stations according to sorted durations
                    sorted_station_pks = sort_by_price(curr_pref_list, travel_traffic_durations, travel_duration, travel_distance, preferred_fuel_prices)
                    # Query stations in sorted order, selecting only the top 3 station for each fuel type
                    curr_pref_list = query_sorted_order(sorted_station_pks[:3])
                    best_station_general[pref] = curr_pref_list

                # API Response
                response = []
                for fuel, preferences_list in best_station_general.items():
                    fuel_response={}
                    fuel_response['fuel_type']=fuel
                    fuel_response['Top 3 Stations']=create_response(preferences_list,travel_traffic_durations,travel_distance,carbon_emission)
                    response.append(fuel_response)

            # Fuel Specific Search
            else:
                preferred_fuel_prices = preferences_list.values_list(fuel_preference, flat=True)
                # Sort stations according to sorted durations
                sorted_station_pks = sort_by_price(preferences_list, travel_traffic_durations, travel_duration, travel_distance, preferred_fuel_prices)
                # Query stations in sorted order
                preferences_list = query_sorted_order(sorted_station_pks[:10])
                # API Response
                response = create_response(preferences_list,travel_traffic_durations,travel_distance,carbon_emission)

    return JsonResponse(response, safe=False, status=200)

@api_view(['POST'])
def review(request):
    """API handles all user requests regarding station reviews."""
    if request.method == 'POST':
        station_id = request.POST['station'] # pk?
        station = Station.objects.get(pk=station_id)
        fuel_prices = FuelPrice.objects.get(station=station)
        user_review, _ = UserReview.objects.get_or_create(station=station)

        if 'receipt' in request.FILES:
            try:
                receipt = request.FILES['receipt']
                s3 = boto3.client(
                    's3',
                    aws_access_key_id="AKIA4O5FKY2EUZ3SY7P4",
                    aws_secret_access_key="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",
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
                return JsonResponse({ 'status':'true', 'message': 'Receipt submitted' }, status=200)
            except Exception as e:
                return JsonResponse({ 'status':'false', 'message': str(e) }, status=500)
        else:
            if request.POST['open'] != "":
                user_review.opening = bool(int(request.POST['open']))

            if request.POST['congestion'] != "":
                user_review.congestion = int(request.POST['congestion'])

            user_review.save()

            if request.POST['unleaded_price'] != "":
                unleaded_price = float(request.POST['unleaded_price']) # Decimal
                if not check_and_update('unleaded_price', unleaded_price, fuel_prices, user_review):
                    return JsonResponse({'status':'false', 'message': 'Exceeded threshold. Please submit receipt.'}, status=555)

            if request.POST['diesel_price'] != "":
                diesel_price = float(request.POST['diesel_price']) # Decimal
                if not check_and_update('diesel_price', diesel_price, fuel_prices, user_review):
                    return JsonResponse({'status':'false', 'message': 'Exceeded threshold. Please submit receipt.'}, status=555)

            if request.POST['super_unleaded_price'] != "":
                super_unleaded_price = float(request.POST['super_unleaded_price']) # Decimal
                if not check_and_update('super_unleaded_price', super_unleaded_price, fuel_prices, user_review):
                    return JsonResponse({'status':'false', 'message': 'Exceeded threshold. Please submit receipt.'}, status=555)

            if request.POST['premium_diesel_price'] != "":
                premium_diesel_price = float(request.POST['premium_diesel_price']) # Decimal
                if not check_and_update('premium_diesel_price', premium_diesel_price, fuel_prices, user_review):
                    return JsonResponse({'status':'false', 'message': 'Exceeded threshold. Please submit receipt.'}, status=555)

            fuel_prices.save()
            user_review.save()
            return JsonResponse({'status':'true', 'message': 'Good.'}, status=200)

