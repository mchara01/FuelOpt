from django.urls import path
from . import views

app_name = 'apis'
urlpatterns = [
    path('', views.ListStation.as_view()),
    path('<int:pk>/', views.DetailStation.as_view()),
    
    # API Routes
    path('home/',views.home, name='home'), # home page
]

