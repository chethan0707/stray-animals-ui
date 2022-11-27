import 'package:geolocator/geolocator.dart';

class GeoLocatorService {
  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    } else {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
