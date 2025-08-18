import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymatvendor/data/models/location.dart';

import '../../widgets/dialogs/scaffold_messanger.dart';

class MapProvider with ChangeNotifier{
  CameraPosition initialCameraPosition =  const CameraPosition(target: LatLng(0.0, 0.0));
  Completer<GoogleMapController>? completer;
  LocationModel? locationModel;
  bool isLoadingCurrentLocation = true;
  bool isLoadingLocation = false;
  Timer? timer;
  void init(){
    initialCameraPosition = const CameraPosition(target: LatLng(0.0, 0.0));
    locationModel = null;
    isLoadingLocation = false;
    isLoadingCurrentLocation = true;
    timer = null;

  }

  void getLocation(Completer<GoogleMapController> completer,String languageId) async{

    this.completer =completer;
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      bool result = await Geolocator.openLocationSettings();
      if(result){
        getLocationData(languageId);
      }
    }else{
      getLocationData(languageId);
    }


  }

  void getLocationData(String languageId) async{
    try{
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: 'Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        CustomScaffoldMessanger.showScaffoledMessanger(
            title: 'Location permissions are permanently denied, we cannot request permissions.');

        return;
      }

      isLoadingCurrentLocation = true;
      notifyListeners();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);


      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude,);
      String? street;
      String? locality;

      if (placemarks.length > 1) {
        street = placemarks[1].thoroughfare ?? placemarks[1].street ??
            placemarks[1].name;
        locality = placemarks[0].locality ?? '';
      } else if (placemarks.length == 1) {
        street = placemarks[0].thoroughfare ?? placemarks[0].street ??
            placemarks[1].name;
        locality = placemarks[0].locality ?? '';
      }
      locationModel = LocationModel(position.latitude, position.longitude, '$street-$locality');
      isLoadingCurrentLocation = false;
      initialCameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude));

      notifyListeners();
      if(completer!=null){
        GoogleMapController controller = await completer!.future;
        controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 15.6));
      }
    }catch(e){
      isLoadingCurrentLocation = true;
      notifyListeners();

    }


  }

  void searchWithText(String text) {

    if(timer!=null&&timer!.isActive){
      timer!.cancel();
    }
    if(text.isEmpty){
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async{
      isLoadingLocation = true;
      notifyListeners();
      List<Location> locations = await locationFromAddress(text);
      if(locations.isNotEmpty){
        locationModel = LocationModel(locations[0].latitude, locations[0].longitude, text);
        initialCameraPosition = CameraPosition(target: LatLng(locations[0].latitude, locations[0].longitude));

        if(completer!=null){
          GoogleMapController controller = await completer!.future;
          controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(locations[0].latitude, locations[0].longitude), 15.6));
        }
      }
      this.timer!.cancel();
      this.timer =null;
      isLoadingLocation = false;
      notifyListeners();
    });


  }

  void searchWithLatLng(double latitude,double longitude,String languageId) {
    if(latitude==0.0&&longitude==0.0){
      return;
    }
    if(timer!=null&&timer!.isActive){
      timer!.cancel();
      timer =null;
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async{
      try{
        isLoadingLocation = true;
        notifyListeners();
        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude,);
        String? street = getStreetName(placemarks);
        String? locality;

        if(placemarks.isNotEmpty){
          locality = placemarks[0].locality ?? '';
        }
        String address ='';
        if(street==null||street.isEmpty){
          address = locality??'';
        }else{
          address = '$street-$locality';
        }
        locationModel = LocationModel(latitude, longitude, address);
        isLoadingLocation = false;
        notifyListeners();

        this.timer!.cancel();
        this.timer =null;
      }catch (e){
        isLoadingLocation = false;
        notifyListeners();

        this.timer!.cancel();
        this.timer =null;
      }

    });


  }

  String? getStreetName(List<Placemark> placemarks){

    for(Placemark placemark in placemarks){
      if(placemark.thoroughfare!=null&&placemark.thoroughfare!.isNotEmpty){
        return placemark.thoroughfare;
      }
    }

    return null;
  }

}