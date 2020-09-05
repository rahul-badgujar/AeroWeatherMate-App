import 'dart:io';
import 'package:location/location.dart';

class GeolocationService {
  static Future<LocationData> getCurrentLocation() async {
    handleLocationService();
    handleLocationPermission();
    LocationData locationData;
    try {
      locationData = await Location.instance.getLocation();
      print("Accessed Location  : " + locationData.toString());
      return locationData;
    } on Exception catch (e) {
      print("Error while accessing Location :" + e.toString());
      locationData = null;
    }
    return locationData;
  }

  static void handleLocationPermission() async {
    PermissionStatus permissionGranted =
        await Location.instance.hasPermission();
    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      print("Location Permission not allowed, Please Allow");
      permissionGranted = await Location.instance.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location Permission Needed, Closing App");
        exit(0);
      }
    }
  }

  static void handleLocationService() async {
    bool serviceEnabled = await Location.instance.serviceEnabled();
    if (serviceEnabled == false) {
      print("Location Service not Enabled, Please enable");
      serviceEnabled = await Location.instance.requestService();
      if (serviceEnabled == false) {
        print("Location Service Needed, Closing App");
        exit(0);
      }
    }
  }
}
