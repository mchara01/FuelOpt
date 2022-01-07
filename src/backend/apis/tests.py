from django.contrib.auth import get_user_model
from django.test import TestCase, Client
import json
import urllib
import os
from stations.models import Station, FuelPrice, UserReview


# Create your tests here.
class APITests(TestCase):

    def setUp(self):
        # user and token
        self.user = get_user_model().objects.create_superuser(
            username='testuser',
            email='test@gmail.com',
            password='secret'
        )
        self.token = \
        json.loads(self.client.post('/apis/token/', {'username': 'testuser', 'password': 'secret'}).content)['token']

        # Station
        self.station1 = Station.objects.create(
            station_id=1,
            lat="51.2954158",
            lng="-0.0713287",
            number_24_7_opening_hours=0,
        )

        self.station2 = Station.objects.create(
            station_id=2,
            lat="51.5261769",
            lng="-0.2177619",
            number_24_7_opening_hours=0,
            air_and_water=1,
            convenience_store=1,
            parking_facilities=1,
        )

        self.station3 = Station.objects.create(
            station_id=3,
            lat="51.4905531",
            lng="-0.2178171",
            number_24_7_opening_hours=1,
            air_and_water=1,
            convenience_store=1,
            parking_facilities=1,
        )

        self.station4 = Station.objects.create(
            station_id=4,
            lat="51.4908270",
            lng="0.1113320",
            number_24_7_opening_hours=1,
            air_and_water=1,
            convenience_store=1,
        )

        # Prices
        self.fuel_price1 = FuelPrice.objects.create(
            station=self.station1,
            unleaded_price="141.90",
            diesel_price="145.90",
            super_unleaded_price="141.90",
            premium_diesel_price=None,
            unleaded_date="2021-10-13",
            diesel_date="2021-10-14",
            super_unleaded_date="2021-10-14",
            premium_diesel_date=None,
        )

        self.fuel_price2 = FuelPrice.objects.create(
            station=self.station2,
            unleaded_price="136.90",
            diesel_price="138.90",
            super_unleaded_price=None,
            premium_diesel_price=None,
            unleaded_date="2021-10-13",
            diesel_date="2021-10-14",
            super_unleaded_date=None,
            premium_diesel_date=None,
        )

        self.fuel_price3 = FuelPrice.objects.create(
            station=self.station3,
            unleaded_price="139.90",
            diesel_price="143.90",
            super_unleaded_price=None,
            premium_diesel_price="155.90",
            unleaded_date="2021-10-13",
            diesel_date="2021-10-14",
            super_unleaded_date=None,
            premium_diesel_date="2021-10-13",
        )

        self.fuel_price4 = FuelPrice.objects.create(
            station=self.station4,
            unleaded_price="136.90",
            diesel_price="142.90",
            super_unleaded_price=None,
            premium_diesel_price=None,
            unleaded_date="2021-10-13",
            diesel_date="2021-10-13",
            super_unleaded_date=None,
            premium_diesel_date=None,
        )

        self.user_review1 = UserReview.objects.create(
            station=self.station1,
            unleaded_price="141.90",
            diesel_price="145.90",
            super_unleaded_price="141.90",
            premium_diesel_price=None,
            opening=True,
            congestion=0,
        )

    """Search API Tests - GET Requests"""

    def test_default(self):
        '''Test 1: default case (all null fields)'''
        # Input Fields
        location = 'Imperial%20College%20London'
        user_pref = ''
        fuel_type = ''
        distance = ''
        amenities = ''

        # Set up client to make requests
        c = Client()
        response = c.get(f'/apis/search', {'user_preference': user_pref, 'location': location, 'fuel_type': fuel_type,
                                           'distance': distance, 'amenities': amenities}, True)

        # API Endpoint
        # routeUrl='http://18.170.63.134:8000/apis/search/?user_preference=' + user_pref + '&location=' + location + '&fuel_type=' + fuel_type + '&distance=' + distance + '&amenities=' + amenities
        # Send get request to search API endpoint and store response
        # response = c.get(routeUrl)

        # Make sure status code is 200
        self.assertEqual(response.status_code, 200)
        self.assertNotEqual(json.loads(response.content)[0]['Top 3 Stations'], [])

    def test_price_without_fuel_type(self):
        '''Test 2: Price optimisation without selecting fuel type.'''
        # Input Fields
        location = 'Imperial%20College%20London'
        user_pref = 'price'
        fuel_type = ''
        distance = ''
        amenities = ''

        # Set up client to make requests
        c = Client()

        # Send get request to search API endpoint and store response
        response = c.get(f'/apis/search', {'user_preference': user_pref, 'location': location, 'fuel_type': fuel_type,
                                           'distance': distance, 'amenities': amenities}, True)
        # Make sure status code is 200
        self.assertEqual(response.status_code, 200)
        self.assertNotEqual(json.loads(response.content)[0]['Top 3 Stations'], [])

    def test_price_with_fuel_type(self):
        '''Test 3: Price optimisation with fuel type selected.'''
        # Input Fields
        location = 'Imperial%20College%20London'
        user_pref = 'price'
        fuel_type = 'unleaded'
        distance = ''
        amenities = ''

        # Set up client to make requests
        c = Client()
        # Send get request to search API endpoint and store response
        response = c.get(f'/apis/search', {'user_preference': user_pref, 'location': location, 'fuel_type': fuel_type,
                                           'distance': distance, 'amenities': amenities}, True)
        # Make sure status code is 200
        self.assertEqual(response.status_code, 200)
        self.assertNotEqual(json.loads(response.content), [])

    def test_time(self):
        '''Test 4: Time optimisation.'''
        # Input Fields
        location = 'Imperial%20College%20London'
        user_pref = 'time'
        fuel_type = ''
        distance = ''
        amenities = ''

        # Set up client to make requests
        c = Client()
        # Send get request to search API endpoint and store response
        response = c.get(f'/apis/search', {'user_preference': user_pref, 'location': location, 'fuel_type': fuel_type,
                                           'distance': distance, 'amenities': amenities}, True)
        # Make sure status code is 200
        self.assertEqual(response.status_code, 200)
        self.assertNotEqual(json.loads(response.content), [])

    def test_eco(self):
        '''Test 5: Eco optimisation.'''
        # Input Fields
        location = 'Imperial%20College%20London'
        user_pref = 'eco'
        fuel_type = ''
        distance = ''
        amenities = ''

        # Set up client to make requests
        c = Client()
        # Send get request to search API endpoint and store response
        response = c.get(f'/apis/search', {'user_preference': user_pref, 'location': location, 'fuel_type': fuel_type,
                                           'distance': distance, 'amenities': amenities}, True)
        # Make sure status code is 200
        self.assertEqual(response.status_code, 200)
        self.assertNotEqual(json.loads(response.content), [])

    def test_amenities(self):
        '''Test 6: Amenities Filters'''
        # Input Fields
        location = 'Imperial%20College%20London'
        user_pref = 'time'
        fuel_type = ''
        distance = ''
        amenities = 'air_and_water,parking_facilities'

        # Set up client to make requests
        c = Client()
        # Send get request to search API endpoint and store response
        response = c.get(f'/apis/search', {'user_preference': user_pref, 'location': location, 'fuel_type': fuel_type,
                                           'distance': distance, 'amenities': amenities}, True)
        # Make sure status code is 200
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(json.loads(response.content)), 2)

    """Review API Tests - POST Requests"""

    def test_upload_by_receipt(self):
        c = Client(HTTP_AUTHORIZATION='Token ' + self.token)
        with open('static/reviews/gas-receipt.png', 'rb') as receipt:
            response = c.post('/apis/review/', {
                'station': 1,
                'receipt': receipt,
            })

        self.fuel_price1.refresh_from_db()

        self.assertEqual(response.status_code, 200)
        self.assertEqual(f'{self.fuel_price1.unleaded_price}', "2.28")

    def test_upload_manually_within_threshold(self):
        c = Client(HTTP_AUTHORIZATION='Token ' + self.token)
        response = c.post('/apis/review/', {
            'station': 1,
            'unleaded_price': 142.0,
            'diesel_price': '',
            'super_unleaded_price': '',
            'premium_diesel_price': '',
            'open': 0,
            'congestion': 5,
        })

        self.fuel_price1.refresh_from_db()
        self.user_review1.refresh_from_db()

        self.assertEqual(response.status_code, 200)
        # test price is updated
        self.assertEqual(f'{self.fuel_price1.unleaded_price}', "142.00")
        # test user review is updated
        self.assertEqual(f'{self.user_review1.unleaded_price}', "142.0")
        self.assertFalse(self.user_review1.opening)
        self.assertEqual(self.user_review1.congestion, 5)

    def test_upload_manually_for_previously_unavailable_fuel(self):
        c = Client(HTTP_AUTHORIZATION='Token ' + self.token)
        response = c.post('/apis/review/', {
            'station': 1,
            'unleaded_price': '',
            'diesel_price': '',
            'super_unleaded_price': '',
            'premium_diesel_price': 148.90,
            'open': 0,
            'congestion': 5,
        })

        self.fuel_price1.refresh_from_db()
        self.user_review1.refresh_from_db()

        self.assertEqual(response.status_code, 555)
        # test price is not changed
        self.assertEqual(f'{self.fuel_price1.unleaded_price}', "141.90")
        self.assertEqual(f'{self.user_review1.unleaded_price}', "141.9")
        # test opening and congestion in user review is updated
        self.assertFalse(self.user_review1.opening)
        self.assertEqual(self.user_review1.congestion, 5)

    def test_upload_manually_outside_threshold(self):
        c = Client(HTTP_AUTHORIZATION='Token ' + self.token)
        response = c.post('/apis/review/', {
            'station': 1,
            'unleaded_price': 1.0,
            'diesel_price': '',
            'super_unleaded_price': '',
            'premium_diesel_price': '',
            'open': 0,
            'congestion': 10,
        })

        self.fuel_price1.refresh_from_db()
        self.user_review1.refresh_from_db()

        self.assertEqual(response.status_code, 555)
        # test price is not changed
        self.assertEqual(f'{self.fuel_price1.unleaded_price}', "141.90")
        self.assertEqual(f'{self.user_review1.unleaded_price}', "141.9")
        # test opening and congestion in user review is updated
        self.assertFalse(self.user_review1.opening)
        self.assertEqual(self.user_review1.congestion, 10)
