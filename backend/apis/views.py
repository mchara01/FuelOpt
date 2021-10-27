from django.shortcuts import render
from rest_framework import generics
from django.db import connection
cursor = connection.cursor()

# Create your views here.
from stations import models
from .serializers import StationSerializer

class ListStation(generics.ListCreateAPIView):

    testquery = cursor.execute('SELECT * FROM stations_station')
    print(testquery)
    row = cursor.fetchone()
    print(row)
    row = cursor.fetchone()
    print(row)


    queryset = models.Station.objects.all() 
    serializer_class = StationSerializer

class DetailStation(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Station.objects.all()
    serializer_class = StationSerializer