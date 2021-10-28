from django.shortcuts import render,redirect
from stations.models import FuelPrice
from rest_framework import generics
from django.contrib import messages
import pandas as pd
import time
from stations.models import Station
import math

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

    data = pd.read_csv('../data/stations_with_coordinates.csv')

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
    data = pd.read_csv('../data/stations_all_info.csv')

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
