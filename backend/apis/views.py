from django.shortcuts import render
from rest_framework import generics
from django.db import connection
from django.http import JsonResponse

cursor = connection.cursor()

# Create your views here.
from stations import models
from .serializers import StationSerializer

class ListStation(generics.ListCreateAPIView):
    queryset = models.Station.objects.all() 
    serializer_class = StationSerializer

class DetailStation(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.Station.objects.all()
    serializer_class = StationSerializer

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
        stations_near_me = models.Station.objects.filter(
            lat__lte=lat_max, lat__gte=lat_min, lng__lte=lng_max, lng__gte=lng_min
        )
    
    # returns a Json list of stations within that page
    return JsonResponse([station.serialize() for station in stations_near_me], safe=False)

