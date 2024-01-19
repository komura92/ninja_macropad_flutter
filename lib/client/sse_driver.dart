import 'package:http/http.dart' as http;
import 'dart:convert';

class SseClient {
  static const String SERVER_URL = 'http://<server-hostname>:2020/sse/notifications?deviceId=1';

  static Future<http.Response> callAction(String action) {
    return http.post(
      Uri.parse(SERVER_URL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'action': action,
      }),
    );
  }
}