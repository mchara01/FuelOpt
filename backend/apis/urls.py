from django.urls import path

from .views import ListStation, DetailStation

urlpatterns = [
    path('', ListStation.as_view()),
    path('<int:pk>/', DetailStation.as_view())
]
