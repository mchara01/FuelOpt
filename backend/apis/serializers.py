from rest_framework import serializers
from drf_yasg import openapi
from stations import models

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


class UserReviewSerializer(serializers.Serializer):
    station = serializers.IntegerField()
    unleaded_price = serializers.CharField(required=False)
    diesel_price = serializers.CharField(required=False)
    super_unleaded_price = serializers.CharField(required=False)
    premium_diesel_price = serializers.CharField(required=False)
    open = serializers.IntegerField(required=False, default=1)
    congestion = serializers.IntegerField(required=False, default=0)
    receipt = serializers.ImageField(required=False)


class UserReviewSummarySerializer(serializers.Serializer):
    open = serializers.IntegerField(required=False, default=1)
    congestion = serializers.IntegerField(required=False, default=0)


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
    duration = serializers.CharField(required=False)
    distance = serializers.CharField(required=False)
    emission = serializers.CharField(required=False)

class StationDetailSerializer3(serializers.ModelSerializer):
    class Meta:
        model = models.Station
        fields = '__all__'
    
    prices = FuelPriceSerializer()
    user_review = UserReviewSummarySerializer()