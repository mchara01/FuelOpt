import pandas as pd
import math
from math import sin, cos, sqrt



def get_data_by_preference():
    df = pd.read_csv("data/stations_all_info.csv")

    # get location,fuel and preference by App UI
    def get_user_location():
        return [51.29550, 0.10291]

    # get the fuel type that the user wants
    def get_user_fuel_type():
        types = ['unleaded', 'super_unleaded', 'diesel', 'premium_diesel']
        return types[0]

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

    user_loc = get_user_location()

    dis_column = []
    for index, row in df.iterrows():
        dis_column.append(get_distance(user_loc[0], user_loc[1], row['lat'], row['lng']))
    df.insert(2, "distance", dis_column, True)

    distance_sorted = df.sort_values(by=['distance'])

    fuel_type = get_user_fuel_type()

    price_sorted = df.sort_values(by=[fuel_type])

    preference = get_user_preference()

    if preference == 'money':
        df = price_sorted
    elif preference == 'distance':
        df = distance_sorted

    return df

