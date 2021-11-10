# Generated by Django 3.2.9 on 2021-11-10 21:44

import datetime
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Station',
            fields=[
                ('name', models.CharField(max_length=200)),
                ('street', models.CharField(max_length=200)),
                ('postcode', models.CharField(max_length=12)),
                ('lat', models.DecimalField(decimal_places=7, max_digits=10)),
                ('lng', models.DecimalField(decimal_places=7, max_digits=10)),
                ('station_id', models.IntegerField(primary_key=True, serialize=False)),
                ('car_wash', models.IntegerField()),
                ('air_and_water', models.IntegerField()),
                ('car_vacuum', models.IntegerField()),
                ('number_24_7_opening_hours', models.IntegerField(db_column='24_7_opening_hours')),
                ('toilet', models.IntegerField()),
                ('convenience_store', models.IntegerField()),
                ('atm', models.IntegerField()),
                ('parking_facilities', models.IntegerField()),
                ('disabled_toilet_baby_change', models.IntegerField()),
                ('alcohol', models.IntegerField()),
                ('wi_fi', models.IntegerField()),
                ('hgv_psv_fueling', models.IntegerField()),
                ('fuelservice', models.IntegerField()),
                ('payphone', models.IntegerField()),
                ('restaurant', models.IntegerField()),
                ('electric_car_charging', models.IntegerField()),
                ('repair_garage', models.IntegerField()),
                ('shower_facilities', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='FuelPrice',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('unleaded_price', models.DecimalField(decimal_places=2, default=None, max_digits=10, null=True)),
                ('diesel_price', models.DecimalField(decimal_places=2, default=None, max_digits=10, null=True)),
                ('super_unleaded_price', models.DecimalField(decimal_places=2, default=None, max_digits=10, null=True)),
                ('premium_diesel_price', models.DecimalField(decimal_places=2, default=None, max_digits=10, null=True)),
                ('unleaded_date', models.DateField(default=datetime.date.today)),
                ('diesel_date', models.DateField(default=datetime.date.today)),
                ('super_unleaded_date', models.DateField(default=datetime.date.today)),
                ('premium_diesel_date', models.DateField(default=datetime.date.today)),
                ('station', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='stations.station')),
            ],
        ),
    ]
