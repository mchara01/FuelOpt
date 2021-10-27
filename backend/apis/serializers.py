from rest_framework import serializers
from stations import models

class StationSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'id',
            'name',
            'location',
            'lat',
            'lng',
            'postcode',
        )
        model = models.Station
