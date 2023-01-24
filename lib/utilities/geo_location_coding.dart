import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GeoLocationCoding {
  late Position _currentPosition;
  late String _currentAddress;

  GeoLocation() {
    _getCurrentLocation();
    _getAddressFromLatLng();
  }

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      _currentPosition = position;
    }).catchError((e) {
      print(e);
    });
  }

  void _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      _currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print(e);
    }
  }

  String getCurrentAddress() {
    return _currentAddress;
  }
}
