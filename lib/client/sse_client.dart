import 'package:flutter_ninja_macropad/config/server_db.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SseClient {
  static Future<http.Response> callAction(String action) {
    return http.post(
      Uri.parse(ServerDB.getSubscriptionUrl()!),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'action': action,
      }),
    );
  }
}