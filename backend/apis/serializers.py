from rest_framework import serializers
from stations import models

class StationSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'id',
            'title',
        )
        model = models.Station
