from rest_framework import serializers
from drf_yasg import openapi
from stations import models
from django.core.validators import MaxValueValidator

class StationSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'station_id',
            'name',
            'street',
            'postcode',
            'lat',
            'lng',
        )
        model = models.Station

class HomeSerializer(serializers.Serializer):
    lat_max = serializers.FloatField(required=True)
    lat_min = serializers.FloatField(required=True)
    lng_max = serializers.FloatField(required=True)
    lng_min = serializers.FloatField(required=True)

class SearchInputSerializer(serializers.Serializer):
    user_preference = serializers.ChoiceField(choices=(('price','price'),("time","time"),("eco","eco")), required=False)
    location = serializers.CharField(required=False)
    lat = serializers.FloatField(required=False)
    lng = serializers.FloatField(required=False)
    distance = serializers.IntegerField(required=False, default=5, validators=[MaxValueValidator(15)])
    fuel_type = serializers.ChoiceField(choices=(('unleaded','unleaded'),("super_unleaded","super_unleaded"),("diesel","diesel"),("premium_diesel","premium_diesel")), required=False)
    amenities = serializers.MultipleChoiceField(choices=(('air_and_water','air_and_water'),("alcohol","alcohol"),("atm","atm"),("car_vacuum","car_vacuum"),("number_24_7_opening_hours","number_24_7_opening_hours"),("toilet","toilet"),("convenience_store","convenience_store"),("parking_facilities","parking_facilities"),("disabled_toilet_baby_change","disabled_toilet_baby_change"),("wi_fi","wi_fi"),("hgv_psv_fueling","hgv_psv_fueling"),("fuelservice","fuelservice"),("payphone","payphone"),("restaurant","restaurant"),("electric_car_charging","electric_car_charging"),("repair_garage","repair_garage"),("shower_facilities","shower_facilities")), required=False)

class UserReviewSerializer(serializers.Serializer):
    station = serializers.IntegerField()
    unleaded_price = serializers.FloatField(required=False)
    diesel_price = serializers.FloatField(required=False)
    super_unleaded_price = serializers.FloatField(required=False)
    premium_diesel_price = serializers.FloatField(required=False)
    open = serializers.IntegerField(required=False, default=1)
    congestion = serializers.IntegerField(required=False, default=0)
    receipt = serializers.ImageField(required=False)

class UserReviewSummarySerializer(serializers.Serializer):
    open = serializers.BooleanField(required=False, default=True)
    congestion = serializers.IntegerField(required=False, default=0)

class FuelPriceSerializer(serializers.Serializer):
    station = serializers.IntegerField()
    unleaded_price = serializers.CharField(required=False)
    diesel_price = serializers.CharField(required=False)
    super_unleaded_price = serializers.CharField(required=False)
    premium_diesel_price = serializers.CharField(required=False)
    unleaded_date = serializers.CharField(required=False)
    diesel_date = serializers.CharField(required=False)
    super_unleaded_date = serializers.CharField(required=False)
    premium_diesel_date = serializers.CharField(required=False)

class StationDetailSerializer1(serializers.ModelSerializer):
    class Meta:
        model = models.Station
        fields = '__all__'
    
    prices = FuelPriceSerializer()

class StationDetailSerializer2(serializers.ModelSerializer):
    class Meta:
        model = models.Station
        fields = '__all__'
    
    prices = FuelPriceSerializer()
    duration = serializers.FloatField(required=False)
    distance = serializers.FloatField(required=False)
    emission = serializers.FloatField(required=False)

class StationDetailSerializer3(serializers.ModelSerializer):
    class Meta:
        model = models.Station
        fields = '__all__'
    
    prices = FuelPriceSerializer()
    user_review = UserReviewSummarySerializer()

