import 'package:helpingworld/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

Future get(String endPoint) async {
  Uri uri = Uri.parse(baseUrl + endPoint);
  var res = await http.get(uri);

  return res;
}

Future post(String endPoint, Map<String, dynamic> body) async {
  Uri uri = Uri.parse(
      baseUrl + endPoint); // 192.168.43.198 = real device id like my phone

  var res = await http.post(uri,
      headers: {"content-type": "application/json"},
      body: convert.jsonEncode(body));

  print(res.statusCode);

  var jsonBody = convert.jsonDecode(res.body);
  print(jsonBody);
  return res;
}

Future put(String endPoint, Map<String, dynamic> body) async {
  Uri uri = Uri.parse(baseUrl + endPoint);
  var res = await http.put(uri,
      headers: {"content-type": "application/json"},
      body: convert.jsonEncode(body));
  return res;
}

Future delete(String endPoint, {body}) async {
  Uri uri = Uri.parse(baseUrl + endPoint);
  var res = await http.delete(uri,
      headers: {"content-type": "application/json"},
      body: convert.jsonEncode(body));
  return res;
}

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if ((connectivityResult == ConnectivityResult.mobile) ||
      (connectivityResult == ConnectivityResult.wifi)) {
    return true;
  } else {
    return false;
  }
}
