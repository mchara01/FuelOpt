from django.db import models
import datetime;

# Create your models here.
class Station(models.Model):
    name = models.CharField(max_length=200,default = "Default Name")
    street = models.CharField(max_length=200,default="Default Street")
    postcode = models.CharField(max_length=12,default="Default Postcode")
    lat = models.DecimalField(decimal_places=7, max_digits=10,default=0.0)
    lng = models.DecimalField(decimal_places=7, max_digits=10, default=0.0)
    station_ref = models.IntegerField(default=0)

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "street": self.street,
            "postcode": self.postcode,
            "latitude": self.lat,
            "longitude":self.lng,
            "station_ref": self.station_ref,
            }
    def __str__(self):
        return 'Station: {}, Id: {}, Ref: {}'.format(self.name, self.id,self.station_ref)

class FuelPrice(models.Model):
    station = models.ForeignKey(Station, on_delete=models.CASCADE)

    unleaded_price = models.DecimalField(decimal_places=2, max_digits=10,default=None, null=True)
    diesel_price = models.DecimalField(decimal_places=2, max_digits=10,default=None, null=True)
    super_unleaded_price = models.DecimalField(decimal_places=2, max_digits=10,default=None, null=True)
    premium_diesel_price = models.DecimalField(decimal_places=2, max_digits=10,default=None, null=True)

    unleaded_date = models.DateField(default=datetime.date.today)
    diesel_date = models.DateField(default=datetime.date.today)
    super_unleaded_date = models.DateField(default=datetime.date.today)
    premium_diesel_date = models.DateField(default=datetime.date.today)

    def serialize(self):
        return {
            "station": self.station.id,
            "unleaded_price": self.unleaded_price,
            "diesel_price": self.diesel_price,
            "super_unleaded_price": self.super_unleaded_price,
            "premium_diesel_price": self.premium_diesel_price,
            "unleaded_date":self.unleaded_date,
            "diesel_date": self.diesel_date,
            "super_unleaded_date": self.super_unleaded_date,
            "premium_diesel_date": self.premium_diesel_date,
            }

    def __str__(self):
        return 'Station: {},Id: {}, Ref: {}'.format(self.station.name, self.id,self.station.station_ref)