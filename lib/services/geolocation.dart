import 'dart:io';
import 'package:location/location.dart';

class GeolocationService {
  static Future<LocationData> getCurrentLocation() async {
    handleLocationService(); // check for Active Status of Location Service
    handleLocationPermission(); // handle Location Permission
    LocationData locationData; // to store LocationData
    try {
      locationData = await Location.instance.getLocation(); // request Locations
      print("Accessed Location  : " + locationData.toString());
      return locationData;
    } on Exception catch (e) {
      // handle and Log Exceptions
      print("Error while accessing Location :" + e.toString());
      locationData = null;
    }
    return locationData;
  }

  // function to handle Location Permission
  static void handleLocationPermission() async {
    PermissionStatus permissionGranted = await Location.instance
        .hasPermission(); // check if permission is granted or not
    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      // if permission not granted
      print("Location Permission not allowed, Please Allow");
      permissionGranted =
          await Location.instance.requestPermission(); // request permission
      if (permissionGranted != PermissionStatus.granted) {
        // if still permission not given
        print("Location Permission Needed to Autofill Cities Details");
      }
    }
  }

  // function to handle Location Service
  static void handleLocationService() async {
    bool serviceEnabled = await Location.instance
        .serviceEnabled(); // check if Location Service is enabled or not
    if (serviceEnabled == false) {
      // if not enabled
      print("Location Service not Enabled, Please enable");
      serviceEnabled = await Location.instance
          .requestService(); // request the Location Service
      if (serviceEnabled == false) {
        // if still service not enabled
        print("Location Permission Needed to Autofill Cities Details");
      }
    }
  }
}
