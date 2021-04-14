import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>> getLocation() async {
  var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
  double longitude = position.longitude;
  double latitude = position.latitude;
  var p = await placemarkFromCoordinates(
      latitude, longitude); // P stands for List<Placemarks>

  String address = p[0].subLocality;
  address = p[0].street +
      ", " +
      p[0].thoroughfare +
      ", " +
      p[0].subLocality +
      ", " +
      p[0].locality +
      ", " +
      p[0].postalCode.toString();
  print(address);

  // print("Adress : $address");
  // print(p[0].name); // Bunter Bhavan
  // print(p[0].administrativeArea); //Maharashtra
  // print(p[0].country); // India
  // print(p[0].isoCountryCode); // IN
  // print(p[0].locality); // Mumbai
  // print(p[0].postalCode); // 400024
  // print(p[0].street); // Buntara Bhavan
  // print(p[0].subAdministrativeArea); // Mumbai Suburban
  // print(p[0].subLocality); // Sion
  // print(p[0].thoroughfare); // Buntar Bhavan Cross Road
  // print(p[0].subThoroughfare);
  return {'longitude': longitude, 'latitude': latitude, 'address': address};
}

String getDate(String createdAt) {
  DateTime time = DateTime.parse(createdAt);
  return DateFormat.MMMMd().format(time);
}

String getTime(String createdAt) {
  DateTime time = DateTime.parse(createdAt);
  return DateFormat.jm().format(time);
}
