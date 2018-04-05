import 'dart:async';
import 'dart:convert';

import 'package:cap_challenge/logic/auth_service.dart';
import 'package:http/http.dart' as http;

const String FIREBASE_URL = 'us-central1-cap-challenge.cloudfunctions.net';

Future<http.Response> sendBottleCode(String code) async {
  String uid = AuthService.instance.currentUser.uid;
  http.Response response = await http.post(
    new Uri.https(FIREBASE_URL, "AddCapCode"),
    headers: {
      "uid": uid,
      "code": code,
      "Accept": "application/json",
      "Content-Type": "application/json"
    },
    body: json.encode({}),
  );
  print(response.statusCode);
  print(response.body);
  return response;
}
