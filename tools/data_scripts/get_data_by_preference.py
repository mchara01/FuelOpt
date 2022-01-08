import pandas as pd
import math
from math import sin, cos, sqrt
import urllib.request
import json

from dotenv import load_dotenv
load_dotenv()
from os import getenv

# bing maps key
bingMapsKey = getenv("BING_MAPS_KEY")

def get_data_by_preference():
    df = pd.read_csv("tools/db_scripts/stations_all_info.csv")

    def get_user_location():
        return [51.29550, -0.10291]

    # get the fuel type that the user wants
    def get_user_fuel_type():
        types = ['unleaded', 'super_unleaded', 'diesel', 'premium_diesel']
        return types[1]

    # what the user's preference, distance or money
    def get_user_preference():
        preferences = ['distance', 'money']
        return preferences[0]

    def deg_to_rad(deg):
        return deg * (math.pi / 180)

    # spherical law of cosines
    def get_distance(lat1, lng1, lat2, lng2):
        # Radius of the earth in km
        r = 6371
        d_lat = deg_to_rad(lat2 - lat1)
        d_lon = deg_to_rad(lng2 - lng1)
        a = sin(d_lat / 2) * sin(d_lat / 2) + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sin(d_lon / 2) * sin(
            d_lon / 2)
        c = 2 * math.atan2(sqrt(a), sqrt(1 - a))
        d = r * c
        return d

    # calculate the travel distance to this station
    def get_travel_duration(lat1, lng1, lat2, lng2):
        routeUrl = "http://dev.virtualearth.net/REST/V1/Routes/Driving?wp.0=" + str(lat1) + "," + str(
            lng1) + "&wp.1=" + str(lat2) + "," + str(lng2) + "&key=" + bingMapsKey

        request = urllib.request.Request(routeUrl)
        response = urllib.request.urlopen(request)

        r = response.read().decode(encoding="utf-8")
        result = json.loads(r)
        duration = result['resourceSets'][0]['resources'][0]['routeLegs'][0]['travelDuration']
        # return the duration
        return duration

    user_loc = get_user_location()

    # sort the stations by distance
    distance_col = []
    for index, row in df.iterrows():
        distance_col.append(get_distance(user_loc[0], user_loc[1], row['lat'], row['lng']))
    df.insert(2, "distance", distance_col, True)

    # keep the 50 nearest stations
    distance_sorted = df.sort_values(by=['distance'])[:50]

    # calculate the duration of the trip
    duration_col = []
    for index, row in distance_sorted.iterrows():
        duration_col.append(get_travel_duration(user_loc[0], user_loc[1], row['lat'], row['lng']))
    distance_sorted.insert(2, "duration", duration_col, True)

    # sort by trip duration
    duration_sorted = distance_sorted.sort_values(by=['duration'])

    preference = get_user_preference()

    if preference == 'money':
        fuel_type = get_user_fuel_type()
        df = df.sort_values(by=[fuel_type])
    elif preference == 'distance':
        df = duration_sorted

    return df