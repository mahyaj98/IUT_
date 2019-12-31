from django.db import models


class Categories(models.Model):
    Name = models.CharField(max_length=20, null=False)
    ID1= models.CharField(max_length=5, unique=True, null=False)


class Country(models.Model):
    Name = models.CharField(max_length=20, null=False)
    ID1 = models.CharField(max_length=5, unique=True, null=False)


class City(models.Model):
    Name = models.CharField(max_length=20, null=False)
    ID1 = models.CharField(max_length=5, unique=True, null=False)
    CountryID = models.ForeignKey(Country, related_name='+', on_delete='cascade')


class Users(models.Model):
    FullName = models.CharField(max_length=20, null=False)
    UserName = models.CharField(max_length=5, unique=True)
    Description = models.CharField(max_length=100)
    CityID = models.ForeignKey(City, related_name='+', on_delete='cascade')
    CountryID = models.ForeignKey(Country, related_name='+', on_delete='cascade')
    Phone = models.CharField(max_length=15)
    Email = models.CharField(max_length=20)


class ProductSale(models.Model):
    ID1 = models.CharField(max_length=5, unique=True, null=False)
    UserName = models.ForeignKey(Users, related_name='+', on_delete='cascade')
    Description = models.CharField(max_length=100, null=False)
    PostDate = models.DateTimeField(auto_now_add=True, null=False)
    ExpirationDate = models.DateTimeField()
    isExpired = models.BooleanField(null=False)
    Price = models.IntegerField(null=False)
    CityID = models.ForeignKey(City, related_name='+', on_delete='cascade')
    CountryID = models.ForeignKey(Country, related_name='+', on_delete='cascade')
    forBorrow = models.BooleanField(null=False)


class ProvideService(models.Model):
    ID1 = models.CharField(max_length=5, unique=True, null=False)
    UserName = models.ForeignKey(Users, related_name='+', on_delete='cascade')
    Description = models.CharField(max_length=100, null=False)
    PostDate = models.DateTimeField(auto_now_add=True, null=False)
    ExpirationDate = models.DateTimeField()
    isExpired = models.BooleanField(null=False)
    Price = models.IntegerField(null=False)
    CityID = models.ForeignKey(City, related_name='+', on_delete='cascade')
    CountryID = models.ForeignKey(Country, related_name='+', on_delete='cascade')
    CategoryID = models.ForeignKey(Categories, related_name='+', on_delete='cascade')


class RequestProduct(models.Model):

    ID1 = models.CharField(max_length=5, unique=True, null=False)
    UserName = models.ForeignKey(Users, related_name='+', on_delete='cascade')
    Description = models.CharField(max_length=100, null=False)
    PostDate = models.DateTimeField(auto_now_add=True, null=False)
    ExpirationDate = models.DateTimeField()
    isExpired = models.BooleanField(null=False)
    Price = models.IntegerField(null=False)
    CityID = models.ForeignKey(City, related_name='+', on_delete='cascade')
    CountryID = models.ForeignKey(Country, related_name='+', on_delete='cascade')


class RequestService(models.Model):
    ID1 = models.CharField(max_length=5, unique=True, null=False)
    UserName = models.ForeignKey(Users, related_name='+', on_delete='cascade')
    Description = models.CharField(max_length=100, null=False)
    PostDate = models.DateTimeField(auto_now_add=True, null=False)
    ExpirationDate = models.DateTimeField()
    isExpired = models.BooleanField(null=False)
    Price = models.IntegerField(null=False)
    CityID = models.ForeignKey(City, related_name='+', on_delete='cascade')
    CountryID = models.ForeignKey(Country, related_name='+', on_delete='cascade')
    CategoryID = models.ForeignKey(Categories, related_name='+', on_delete='cascade')


