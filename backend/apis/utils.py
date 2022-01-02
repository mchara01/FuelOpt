import urllib.request
import json
import pytesseract
import re

from stations.models import FuelPrice
from decimal import Decimal
from datetime import datetime
from .config import LOCATION_IQ_KEY, KEY_1, KEY_2


def geocoding_with_name(location):
    location_iq_key = LOCATION_IQ_KEY
    routeUrl = "https://eu1.locationiq.com/v1/search.php?key=" + location_iq_key + "&q=" + str(
        location.replace(' ', '%20')) + "%20London" + "&format=json"

    request = urllib.request.Request(routeUrl)
    response = urllib.request.urlopen(request)

    r = response.read().decode(encoding="utf-8")
    result = json.loads(r)

    if result[0]['lat']:
        return float(result[0]['lat']), float(result[0]['lon'])
    else:
        raise ValueError('Unable to geocode')


def geocoding_with_postcode(postcode):
    routeUrl = "http://api.getthedata.com/postcode/" + postcode.replace(' ', '+')
    request = urllib.request.Request(routeUrl)
    response = urllib.request.urlopen(request)

    r = response.read().decode(encoding="utf-8")
    result = json.loads(r)

    try:
        latitude = float(result['data']['latitude'])
        longitude = float(result['data']['longitude'])
        print('lat lng found')
        return latitude, longitude
    except KeyError:
        raise ValueError('Unable to geocode')


# Calculate the travel duration to this station
def get_duration_distance(lat1, lng1, lat2, lng2, key, s):
    a = KEY_1
    b = KEY_2

    if key == 'a':
        bingMapsKey = a
    else:
        bingMapsKey = b

    routeUrl = "http://dev.virtualearth.net/REST/V1/Routes/Driving?wp.0=" + str(lat1) + "," + str(
        lng1) + "&wp.1=" + str(lat2) + "," + str(lng2) + "&key=" + bingMapsKey
    # http://dev.virtualearth.net/REST/V1/Routes/Driving?wp.0=51.0,-0.1&wp.1=51.1,-0.12&key=Aiiv3MUtA8Fq3gGOuwLYLrzz_FRSm1xXUEgDZxO6-R8wg73PKwV50hxqwSrbBhXY
    # request = urllib.request.Request(routeUrl)
    response = s.get(routeUrl)
    # r = response.read().decode(encoding="utf-8")
    result = response.json()

    duration = result['resourceSets'][0]['resources'][0]['travelDuration']  # units: s
    duration_with_traffic = result['resourceSets'][0]['resources'][0]['travelDurationTraffic']  # units: s
    distance = result['resourceSets'][0]['resources'][0]['travelDistance']  # units: km

    # return the duration and distance
    return duration_with_traffic, duration, distance


def sort_by_price(preferences_list, travel_traffic_durations, travel_duration, travel_distance, preferred_fuel_prices):
    """
    preferences_list(query object): list of potential station candidates
    """
    # Parameters Used:
    # Fuel Economy: 0.07 litres per km
    # Idle Consumption: 0.0003157 litres per s

    weighted_prices = dict()
    for index, fuel_price in enumerate(preferences_list):
        weighted_prices[fuel_price.station.pk] = 50 * preferred_fuel_prices[index] + Decimal(
            travel_distance[fuel_price.station.pk] * 0.07) * preferred_fuel_prices[index] + Decimal(
            (travel_traffic_durations[fuel_price.station.pk] - travel_duration[fuel_price.station.pk]) * 0.0003157) * \
                                                 preferred_fuel_prices[index]

    sorted_weighted_prices = {k: v for k, v in sorted(weighted_prices.items(), key=lambda item: item[1])}
    print(sorted_weighted_prices)
    sorted_station_pks = list(sorted_weighted_prices.keys())

    return sorted_station_pks


def query_sorted_order(pk_list):
    """ Query stations in sorted order and append into a list. """
    preferences_list = []
    for pk in pk_list:
        preferences_list.append(FuelPrice.objects.get(station_id=pk))

    return preferences_list


def create_response(preferences_list, travel_traffic_durations, travel_distance, carbon_emission):
    response = []
    for fuel_price in preferences_list[:20]:
        station_response = fuel_price.station.serialize()
        station_response['prices'] = fuel_price.serialize()
        station_response['duration'] = str(int(travel_traffic_durations[fuel_price.station.pk] / 60)) + 'mins'
        station_response['distance'] = str(travel_distance[fuel_price.station.pk]) + 'km'
        station_response['emission'] = str(round(carbon_emission[fuel_price.station.pk], 2)) + 'kgCO2'
        response.append(station_response)

    return response


def check_and_update(fuel_type, price, fuel_prices, user_review):
    # If price was previously None
    if getattr(fuel_prices, fuel_type) is None:
        return False

    # If price was previously available
    if (float(getattr(fuel_prices, fuel_type)) * 1.05 > price > float(getattr(fuel_prices, fuel_type)) * 0.95) or price == 0:
        if price == 0:
            setattr(fuel_prices, fuel_type, None)
            setattr(user_review, fuel_type, None)
        else:
            setattr(fuel_prices, fuel_type, price)
            setattr(user_review, fuel_type, price)
        return True
    else:
        return False


# image of receipt of user
def read_receipt(filepath):
    # image of receipt of user
    text = pytesseract.image_to_string(filepath)
    text = text.splitlines()

    price = None

    elements = []
    for line in text:
        # find line that mentions @
        if '@' in line:
            elements = line.split()

    for i in range(len(elements)):
        if elements[i] == '@':
            try:
                price = elements[i + 1]
            except Exception:
                pass
    elements = []
    for line in text:
        # find line that mentions price
        if 'PRICE' in line:
            elements = line.split()

    # search for float value in price line
    for e in elements:
        try:
            # remove currency icon and replace coma with dot
            e = re.sub('£', '', e)
            e = re.sub('\$', '', e)
            e = re.sub('€', '', e)
            e = re.sub(',', '.', e)
            price = float(str(e))
        except ValueError:
            continue

    # find line that mentions product
    type_of_fuel = None
    elements = []
    for line in text:
        if 'PRODUCT' in line:
            elements = line.split()

    # the word after product is the type of fuel
    if len(elements) > 1:
        type_of_fuel = elements[1]

    # change capital letters and shorted words to normal wording
    if type_of_fuel == 'UNLEADED' or type_of_fuel == 'UNLD':
        type_of_fuel = 'unleaded'

    if type_of_fuel == 'DIESEL' or type_of_fuel == 'DSL' or type_of_fuel == 'Regular Diesel' \
            or type_of_fuel == 'REGULAR DIESEL':
        type_of_fuel = 'diesel'

    if type_of_fuel == 'SUPER UNLEADED' or type_of_fuel == 'SUNLD':
        type_of_fuel = 'super_unleaded'

    if type_of_fuel == 'PREMIUM UNLEADED' or type_of_fuel == 'PDSL':
        type_of_fuel = 'premium_diesel'

    date = None
    for t in text:
        text2 = t.split(' ')
        for i in range(len(text2)):
            try:
                date = datetime.strptime(text2[i], '%d/%m/%Y')
            except ValueError:
                pass
            try:
                date = datetime.strptime(text2[i], '%d/%m/%y')
            except ValueError:
                pass
            try:
                date = datetime.strptime(text2[i], '%Y/%m/%d')
            except ValueError:
                pass

    return price, type_of_fuel, date
