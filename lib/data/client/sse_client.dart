import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_ninja_macropad/data/db/server_db.dart';
import 'package:flutter_ninja_macropad/utils/toast_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SseClient {
  static final _deviceNames = DeviceMarketingNames();
  static Function(SSEModel event) _sseEventCallback = (event) {};

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
    try {
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
    ToastUtils.showToast(context,
        "Set server URL and device ID in connection settings to perform actions");
  }

  static void updateSubscriptionCallback(Function(SSEModel event) callback) {
    _sseEventCallback = callback;
  }

  static void subscribe() {
    _deviceNames.getSingleName().then((deviceId) {
      if (ServerDB.getSseSubscriptionUrl(deviceId) == null) {
        return;
      }
      SSEClient.subscribeToSSE(
          method: SSERequestType.GET,
          url: ServerDB.getSseSubscriptionUrl(deviceId)!,
          header: {
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
          }).listen((event) => _sseEventCallback(event));
    });
  }
}
