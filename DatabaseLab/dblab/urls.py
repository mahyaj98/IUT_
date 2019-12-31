from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('Cat/', views.Cat, name='Cat'),
    path('Cat/', views.Count, name='Count'),
    path('Cat/', views.City, name='City'),
    path('Cat/', views.User, name='User'),
    path('Cat/', views.RequestProduct, name='RequestProduct'),
    path('Cat/', views.RequestService, name='RequestService'),


]