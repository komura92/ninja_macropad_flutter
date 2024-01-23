import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/data/db/server_db.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SseClient {
  static Future<http.Response>? callAction(
      String action, BuildContext context) {
    if (ServerDB.getPublishUrl() == null) {
      _missingConfigError(context);
      return null;
    }

    return http.post(
      Uri.parse(ServerDB.getPublishUrl()!),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'action': action,
      }),
    );
  }

  static Future<List<String>> getAvailableDevices(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    if (ServerDB.getDevicesUrl() == null) {
      _missingConfigError(context);
      return Future.value([]);
    }
    try {
      final response = await http
          .get(Uri.parse(ServerDB.getDevicesUrl()!))
          .timeout(const Duration(seconds: 5));
      List responseList = json.decode(response.body);
      List<String> list = responseList.map((e) => e as String).toList();
      return Future.value(list);
    } catch (e) {
      return Future.value([]);
    } finally {
      Navigator.of(context).pop();
    }
  }

  static void _missingConfigError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Set server URL and device ID to perform actions"),
    ));
  }
}
