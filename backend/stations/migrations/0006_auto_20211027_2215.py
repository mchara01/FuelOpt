# Generated by Django 3.2.8 on 2021-10-27 21:15

import datetime
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('stations', '0005_remove_station_price'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='station',
            name='location',
        ),
        migrations.AddField(
            model_name='station',
            name='station_ref',
            field=models.IntegerField(default=0),
        ),
        migrations.AddField(
            model_name='station',
            name='street',
            field=models.CharField(default='Default Street', max_length=200),
        ),
        migrations.AlterField(
            model_name='station',
            name='name',
            field=models.CharField(default='Default Name', max_length=200),
        ),
        migrations.AlterField(
            model_name='station',
            name='postcode',
            field=models.CharField(default='Default Postcode', max_length=12),
        ),
        migrations.CreateModel(
            name='FuelPrice',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('unleaded_price', models.DecimalField(decimal_places=2, default=0.0, max_digits=10)),
                ('diesel_price', models.DecimalField(decimal_places=2, default=0.0, max_digits=10)),
                ('super_unleaded_price', models.DecimalField(decimal_places=2, default=0.0, max_digits=10)),
                ('premium_unleaded_price', models.DecimalField(decimal_places=2, default=0.0, max_digits=10)),
                ('unleaded_date', models.DateField(default=datetime.date.today)),
                ('diesel_date', models.DateField(default=datetime.date.today)),
                ('super_unleaded_date', models.DateField(default=datetime.date.today)),
                ('premium_unleaded_date', models.DateField(default=datetime.date.today)),
                ('station', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='stations.station')),
            ],
        ),
    ]