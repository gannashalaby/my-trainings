from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("<str:name>", views.greet, name="greet"),
    path("ganna", views.ganna, name="ganna"),
    path("david", views.david, name="david"),
]