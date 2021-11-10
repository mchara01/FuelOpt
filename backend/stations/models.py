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
    number_24_7_opening_hours = models.IntegerField(db_column='24_7_opening_hours')  # Field renamed because it wasn't a valid Python identifier.
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

class FuelPrice(models.Model):
    id = models.BigAutoField(primary_key=True)
    unleaded_price = models.DecimalField(max_digits=4, decimal_places=1, blank=True, null=True)
    diesel_price = models.DecimalField(max_digits=4, decimal_places=1, blank=True, null=True)
    super_unleaded_price = models.DecimalField(max_digits=4, decimal_places=1, blank=True, null=True)
    premium_diesel_price = models.DecimalField(max_digits=4, decimal_places=1, blank=True, null=True)
    unleaded_date = models.DateField(blank=True, null=True)
    diesel_date = models.DateField(blank=True, null=True)
    super_unleaded_date = models.DateField(blank=True, null=True)
    premium_diesel_date = models.DateField(blank=True, null=True)
    station = models.ForeignKey('Station', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'stations_fuelprice'
