// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grocery_app/core/helpers/constants.dart';
import 'package:grocery_app/core/helpers/shared_pref_helper.dart';

class LocationProvider with ChangeNotifier {
  double? latitude;
  double? longitude;
  bool permissionAllowed = false;
  bool isLoading = false;
  Placemark? selectedAddress;

  Future<void> fetchCurrentLocation() async {
    isLoading = true;
    notifyListeners();
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('Location services are disabled.');
        permissionAllowed = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Location permission denied');
          permissionAllowed = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('Location permission permanently denied');
        permissionAllowed = false;
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude;
      longitude = position.longitude;
      permissionAllowed = true;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      log("Location error: $e");
      permissionAllowed = false;
      isLoading = false;
      notifyListeners();
    }
  }

  void onCameraMove(MapCamera position) {
    latitude = position.center.latitude;
    longitude = position.center.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    if (latitude != null && longitude != null) {
      try {
        isLoading = true;
        notifyListeners();
        List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude!,
          longitude!,
        );
        if (placemarks.isNotEmpty) {
          selectedAddress = placemarks.first;
          log(
            "📍 Selected Address Updated: ${selectedAddress!.street}, ${selectedAddress!.locality}, ${selectedAddress!.country}",
          );
          notifyListeners();
        }
      } catch (e) {
        log("❌ Error fetching address: $e");
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void setLocationFromFirestore({
    required double lat,
    required double lng,
    String? address,
  }) {
    latitude = lat;
    longitude = lng;

    if (address != null && address.isNotEmpty) {
      selectedAddress = Placemark(street: address);
    }

    notifyListeners();
  }

  Future<void> saveUserLocation(String location) async {
    await SharedPrefHelper.setData(SharedPrefKeys.userlocation, location);
  }
}
