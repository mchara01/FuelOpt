from rest_framework import serializers
from stations import models

class StationSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'id',
            'name',
            'street',
            'postcode',
            'lat',
            'lng',
            'station_ref',
        )
        model = models.Station
