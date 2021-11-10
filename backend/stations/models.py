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
    car_wash = models.IntegerField()
    air_and_water = models.IntegerField()
    car_vacuum = models.IntegerField()
    number_24_7_opening_hours = models.IntegerField( db_column='24_7_opening_hours')
    toilet = models.IntegerField()
    convenience_store = models.IntegerField()
    atm = models.IntegerField()
    parking_facilities = models.IntegerField()
    disabled_toilet_baby_change = models.IntegerField()
    alcohol = models.IntegerField()
    wi_fi = models.IntegerField()
    hgv_psv_fueling = models.IntegerField()
    fuelservice = models.IntegerField()
    payphone = models.IntegerField()
    restaurant = models.IntegerField()
    electric_car_charging = models.IntegerField()
    repair_garage = models.IntegerField()
    shower_facilities = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'stations_station'

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
    station = models.ForeignKey(Station, on_delete=models.CASCADE)

    unleaded_price = models.DecimalField(
        decimal_places=2, max_digits=10, default=None, null=True)
    diesel_price = models.DecimalField(
        decimal_places=2, max_digits=10, default=None, null=True)
    super_unleaded_price = models.DecimalField(
        decimal_places=2, max_digits=10, default=None, null=True)
    premium_diesel_price = models.DecimalField(
        decimal_places=2, max_digits=10, default=None, null=True)

    unleaded_date = models.DateField(default=datetime.date.today)
    diesel_date = models.DateField(default=datetime.date.today)
    super_unleaded_date = models.DateField(default=datetime.date.today)
    premium_diesel_date = models.DateField(default=datetime.date.today)

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
