from django.urls import path
from . import views
from rest_framework.authtoken.views import obtain_auth_token
app_name= 'apis'

urlpatterns = [
    path('', views.ListStation.as_view()),
    path('<int:pk>/', views.DetailStation.as_view()),
    path('temp_admin', views.temp_admin, name="temp_admin"),
    path('home/',views.home, name='home'), # home page
    path('nearest/', views.nearestStation, name='nearest'),
    path('token/', obtain_auth_token, name='obtain-token'),
]

