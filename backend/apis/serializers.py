from rest_framework import serializers
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
