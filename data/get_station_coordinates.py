import pandas as pd
import requests

station_info = pd.read_csv('stations.csv', usecols=['name', 'station_id', 'station_location'])

latitudes = []
longitudes = []

for index, row in station_info.iterrows():
    station_location = row['name'] + ", " +row['station_location']
    r = requests.get('https://maps.googleapis.com/maps/api/geocode/json?address={location}&key=AIzaSyDgUnhyTvq7bpZ1RR2-wFpNZ1GA2pd8WTQ'.format(location = station_location))
    data = r.json()
    latitude = data['results'][0]['geometry']['location']['lat']
    longitude = data['results'][0]['geometry']['location']['lng']
    latitudes.append(latitude)
    longitudes.append(longitude)

station_info['lat'] = latitudes
station_info['lng'] = longitudes
# print(station_info)
station_info.to_csv("stations_with_coordinates.csv")