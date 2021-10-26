from django.db import models

# Create your models here.
class Station(models.Model):
    name = models.CharField(max_length=200)
    location = models.CharField(max_length=200)
    lat = models.DecimalField(decimal_places=7)
    lng = models.DecimalField(decimal_places=7)
    time = models.DateTimeField(auto_now_add=True) # Time added automatically

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "location": self.location,
            "latitude": self.lat,
            "longitude":self.lng,
            "time":self.time.strftime("%b %d %Y, %I:%M %p")
            }
    
