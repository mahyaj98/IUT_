from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse
from django.forms import Form
from django.contrib.auth.models import User
from django.shortcuts import render, redirect, get_object_or_404
from .models import Categories, Users, Country, City, RequestProduct, RequestService, ProductSale, ProvideService
from django.template import loader


def index(request):
    template = loader.get_template('Cat.html')
    context = {
    }
    return HttpResponse(template.render(context, request))


def Cat(request):
    id1 = request.POST['id1']
    name = request.POST['name']

    cat = Categories(ID1=id1, Name=name)
    cat.save()

    return render(request, 'Cat.html', {'Category': cat})


def Count(request):
    id1 = request.POST['id1']
    name = request.POST['name']

    count = Country(ID1=id1, Name=name)
    count.save()

    return render(request, 'Cat.html', {'Country': count})


def City(request):
    id1 = request.POST['id1']
    name = request.POST['name']
    coid = request.POST['coid']

    city = City(ID1=id1, Name=name, CountryID=coid)
    city.save()

    return render(request, 'Cat.html', {'Country': city})


def User(request):
    fn = request.POST['fn']
    un = request.POST['un']
    email = request.POST['email']
    phone = request.POST['phone']
    desc = request.POST['desc']
    ciid = request.POST['ciid']
    coid = request.POST['coid']

    user = Users(FullName=fn, UserName=un, Email=email, CountryID=coid, CityID=ciid, Phone=phone, Description=desc)

    user.save()

    return render(request, 'Cat.html', {'User': user})


def RequestProduct(request):
    id = request.POST['id']
    un = request.POST['un']
    desc = request.POST['desc']
    ciid = request.POST['ciid']
    coid = request.POST['coid']
    post = request.POST['post']
    expire = request.POST['expire']
    price = request.POST['price']

    rp = RequestProduct(ID1=id, UserName=un, Description=desc, PostDate=post, ExpirationDate=expire, isExpired=0, Price=price, CountryID=coid, CityID=ciid)

    rp.save()

    return render(request, 'Cat.html', {'RequestProduct': rp})

def RequestService(request):

    id = request.POST['id']
    un = request.POST['un']
    desc = request.POST['desc']
    ciid = request.POST['ciid']
    coid = request.POST['coid']
    post = request.POST['post']
    expire = request.POST['expire']
    price = request.POST['price']
    cat = request.POST['cat']

    rp = RequestProduct(ID1=id, UserName=un, Description=desc, PostDate=post, ExpirationDate=expire, isExpired=0, Price=price, CountryID=coid, CityID=ciid, Category=cat)

    rp.save()

    return render(request, 'Cat.html', {'RequestProduct': rp})