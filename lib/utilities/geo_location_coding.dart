import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:developer' as dev;

class GeoLocationCoding {
  late String _currentAddress = '';

  Future<Position> _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String> getCurrentAddress() async {
    if (_currentAddress != '') {
      return _currentAddress;
    }
    dev.log("Getting address");
    final position = await _getCurrentLocation();

    if (position != null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];
      _currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
      return _currentAddress;
    } else {
      return 'Address Not Available';
    }
  }
}
