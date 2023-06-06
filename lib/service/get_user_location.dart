
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';



class GetUserLocation{
  static String info = "";
  static String? currentAddress;
  static Position? currentPosition;

  static Future<bool> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return hasPermission;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
        currentPosition = position;
    }).catchError((ex) {
      throw Exception('Current Position error: ${ex.toString()}');
    });
    await getAddressFromLatLng(currentPosition!);
    return hasPermission;
  }

  static Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      currentAddress = '${place.subAdministrativeArea} - ${place.postalCode}';
      print("Address ${currentAddress}");
    }).catchError((ex) {
      throw Exception('Current Address error: ${ex.toString()}');
    });
  }

  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      info = 'Location services are disabled. Please enable the services.';
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        info = 'Location permissions are denied.';
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      info = 'Location permissions are permanently denied, we cannot request permissions.';
      return false;
    }
    return true;
  }
}