# Generated by Django 3.2.8 on 2021-10-27 20:26

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stations', '0004_station_price'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='station',
            name='price',
        ),
    ]