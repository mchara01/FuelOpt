from django.db import models
from datetime import datetime;

# Create your models here.
class Station(models.Model):
    name = models.CharField(max_length=200)
    location = models.CharField(max_length=200,default="Default")
    lat = models.DecimalField(decimal_places=7, max_digits=10,default=0.0)
    lng = models.DecimalField(decimal_places=7, max_digits=10, default=0.0)
    postcode = models.CharField(max_length=12,default="")
    price = models.DecimalField(decimal_places=7, max_digits=10, default=0.0)

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "location": self.location,
            "latitude": self.lat,
            "longitude":self.lng,
            "postcode": self.postcode
            }
    
