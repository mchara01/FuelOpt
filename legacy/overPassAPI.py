#!/bin/python3

import requests
import json

overpass_url = "http://overpass-api.de/api/interpreter"
overpass_query = "[out:json];area(3600065606);node[amenity=fuel](area);out;"
response = requests.get(overpass_url, params={'data': overpass_query})
response = response.json()
stations = response['elements']

for station in stations:
	print("Lat: " + str(station["lat"]))
	print("Lon: " + str(station["lon"]))
	if "name" in station["tags"]:
		print("Name: " + str(station["tags"]["name"]))
	else:
		print("Name: N/A")
	if "addr:city" in station["tags"]:
		print("City: " + str(station["tags"]["addr:city"]))
	else:
		print("City: N/A")
	if "addr:postcode" in station["tags"]:
		print("Postcode: " + str(station["tags"]["addr:postcode"]))
	else:
		print("Postcode: N/A")
	if "addr:street" in station["tags"]:
		print("Street: " + str(station["tags"]["addr:street"]))
	else:
		print("Street: N/A")
	if "opening_hours" in station["tags"]:
		print("Opening Hours: " + str(station["tags"]["opening_hours"]))
	else:
		print("Opening Hours: N/A")
	if "phone" in station["tags"]:
		print("Phone: " + str(station["tags"]["phone"]))
	else:
		print("Phone: N/A")
	if "website" in station["tags"]:
		print("Website: " + str(station["tags"]["website"]))
	else:
		print("Website: N/A")
	print()