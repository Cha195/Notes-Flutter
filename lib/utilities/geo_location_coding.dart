import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:developer' as dev;

class GeoLocationCoding {
  late String _currentAddress = '';
  Future<Position?> _getCurrentLocation() async {
    dev.log("Getting position");
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        forceAndroidLocationManager: true,
      );
      dev.log(position.toString());
      return position;
    } catch (e) {
      dev.log(e.toString());
    }
  }

  Future<String> getCurrentAddress() async {
    if(_currentAddress != '') {
      return _currentAddress;
    }
    dev.log("Getting address");
    final position = await _getCurrentLocation();

    if (position != null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];
      _currentAddress =  "${place.locality}, ${place.postalCode}, ${place.country}";
      return _currentAddress;
    } else {
      return 'Address Not Available';
    }
  }
}
