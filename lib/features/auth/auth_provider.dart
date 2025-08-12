import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jh_aplicacion/main.dart';

final loginProvider = FutureProvider.family<bool, Map<String, String>>((ref, creds) async {
  final res = await http.post(
    Uri.parse('http://3.142.35.195:5000/clinica/api/authenticate'),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    },
    body: {
      'username': creds['username'] ?? '',
      'password': creds['password'] ?? '',
    },
  );


if (res.statusCode == 200) {
  final data = jsonDecode(res.body);
  final token = data['access_token'];
  ref.read(authTokenProvider.notifier).state = token;
  return true;
}


  return false;
});

