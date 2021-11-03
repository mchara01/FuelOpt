from django.contrib import admin

from .models import Station, FuelPrice

# Register your models here.
admin.site.register(Station)
admin.site.register(FuelPrice)