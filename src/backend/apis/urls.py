from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token
from . import views

app_name = 'apis'

urlpatterns = [
    path('', views.ListStation.as_view()),
    path('station/<int:station_id>', views.detailStation, name='detail'),
    path('temp_admin', views.temp_admin, name="temp_admin"),
    path('home/', views.home, name='home'),  # home page
    path('token/', obtain_auth_token, name='obtain-token'),
    path('search/', views.search, name='search'),
    path('review/', views.review, name='review'),
]
