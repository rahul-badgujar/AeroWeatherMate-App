import 'package:geolocator/geolocator.dart';

class GeolocationService {
  static Future<Position> getCurrentLiveLocation() async {
    Position location = await getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);
    return location;
  }
}
