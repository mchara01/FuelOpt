from django.db import models
import datetime

# Create your models here.


class Station(models.Model):
    name = models.CharField(max_length=200)
    street = models.CharField(max_length=200)
    postcode = models.CharField(max_length=12)
    lat = models.DecimalField(max_digits=10, decimal_places=7)
    lng = models.DecimalField(max_digits=10, decimal_places=7)
    station_id = models.IntegerField(primary_key=True)
    car_wash = models.IntegerField(default=0)
    air_and_water = models.IntegerField(default=0)
    car_vacuum = models.IntegerField(default=0)
    number_24_7_opening_hours = models.IntegerField(db_column='24_7_opening_hours')
    toilet = models.IntegerField(default=0)
    convenience_store = models.IntegerField(default=0)
    atm = models.IntegerField(default=0)
    parking_facilities = models.IntegerField(default=0)
    disabled_toilet_baby_change = models.IntegerField(default=0)
    alcohol = models.IntegerField(default=0)
    wi_fi = models.IntegerField(default=0)
    hgv_psv_fueling = models.IntegerField(default=0)
    fuelservice = models.IntegerField(default=0)
    payphone = models.IntegerField(default=0)
    restaurant = models.IntegerField(default=0)
    electric_car_charging = models.IntegerField(default=0)
    repair_garage = models.IntegerField(default=0)
    shower_facilities = models.IntegerField(default=0)

    def serialize(self):
        return {
            "station_id": self.station_id,
            "name": self.name,
            "street": self.street,
            "postcode": self.postcode,
            "latitude": self.lat,
            "longitude": self.lng,
            "car_wash": self.car_wash,
            "air_and_water": self.air_and_water,
            "car_vacuum": self.car_vacuum,
            "number_24_7_opening_hours": self.number_24_7_opening_hours,
            "toilet": self.toilet,
            "convenience_store": self.convenience_store,
            "atm": self.atm,
            "parking_facilities": self.parking_facilities,
            "disabled_toilet_baby_change": self.disabled_toilet_baby_change,
            "alcohol": self.alcohol,
            "wi_fi": self.wi_fi,
            "hgv_psv_fueling": self.hgv_psv_fueling,
            "fuelservice": self.fuelservice,
            "payphone": self.payphone,
            "restaurant": self.restaurant,
            "electric_car_charging": self.electric_car_charging,
            "repair_garage": self.repair_garage,
            "shower_facilities": self.shower_facilities,
        }

    def __str__(self):
        return 'Station: {}, Id: {}, Ref: {}'.format(self.name, self.station_id)


class FuelPrice(models.Model):
    station = models.ForeignKey(Station, on_delete=models.CASCADE, to_field='station_id')

    unleaded_price = models.DecimalField(
        decimal_places=2, max_digits=10, default=None, null=True)
    diesel_price = models.DecimalField(
        decimal_places=2, max_digits=10, default=None, null=True)
    super_unleaded_price = models.DecimalField(
        decimal_places=2, max_digits=10, default=None, null=True)
    premium_diesel_price = models.DecimalField(
        decimal_places=2, max_digits=10, default=None, null=True)

    unleaded_date = models.DateField(null=True)
    diesel_date = models.DateField(null=True)
    super_unleaded_date = models.DateField(null=True)
    premium_diesel_date = models.DateField(null=True)

    def serialize(self):
        return {
            "station": self.station.station_id,
            "unleaded_price": self.unleaded_price,
            "diesel_price": self.diesel_price,
            "super_unleaded_price": self.super_unleaded_price,
            "premium_diesel_price": self.premium_diesel_price,
            "unleaded_date": self.unleaded_date,
            "diesel_date": self.diesel_date,
            "super_unleaded_date": self.super_unleaded_date,
            "premium_diesel_date": self.premium_diesel_date,
        }

    def __str__(self):
        return 'Station: {},Id: {}, Ref: {}'.format(self.station.name, self.id, self.station.station_id)

class UserReview(models.Model):
    station = models.ForeignKey(
        Station, on_delete=models.CASCADE, to_field='station_id')

    unleaded_price = models.DecimalField(
        decimal_places=1, max_digits=4, default=None, null=True)
    diesel_price = models.DecimalField(
        decimal_places=1, max_digits=4, default=None, null=True)
    super_unleaded_price = models.DecimalField(
        decimal_places=1, max_digits=4, default=None, null=True)
    premium_diesel_price = models.DecimalField(
        decimal_places=1, max_digits=4, default=None, null=True)

    receipt = models.ImageField(upload_to='receipts/', blank=True, null=True)
    opening = models.BooleanField(null=True)
    congestion = models.IntegerField(null=True)
