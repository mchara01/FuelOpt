# Generated by Django 3.2.8 on 2021-10-27 16:25

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('stations', '0003_station_postcode'),
    ]

    operations = [
        migrations.AddField(
            model_name='station',
            name='price',
            field=models.DecimalField(decimal_places=7, default=0.0, max_digits=10),
        ),
    ]