# Generated by Django 3.2.9 on 2021-11-08 10:42

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
                ('name', models.CharField(default='Default Name', max_length=200)),
                ('street', models.CharField(default='Default Street', max_length=200)),
                ('postcode', models.CharField(default='Default Postcode', max_length=12)),
                ('lat', models.DecimalField(decimal_places=7, default=0.0, max_digits=10)),
                ('lng', models.DecimalField(decimal_places=7, default=0.0, max_digits=10)),
                ('station_id', models.IntegerField(primary_key=True, serialize=False)),
            ],
        ),
        migrations.CreateModel(
            name='FuelPrice',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('unleaded_price', models.DecimalField(decimal_places=1, default=None, max_digits=4, null=True)),
                ('diesel_price', models.DecimalField(decimal_places=1, default=None, max_digits=4, null=True)),
                ('super_unleaded_price', models.DecimalField(decimal_places=1, default=None, max_digits=4, null=True)),
                ('premium_diesel_price', models.DecimalField(decimal_places=1, default=None, max_digits=4, null=True)),
                ('unleaded_date', models.DateField(default=None, null=True)),
                ('diesel_date', models.DateField(default=None, null=True)),
                ('super_unleaded_date', models.DateField(default=None, null=True)),
                ('premium_diesel_date', models.DateField(default=None, null=True)),
                ('station', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='stations.station')),
            ],
        ),
    ]
