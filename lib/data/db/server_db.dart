import 'package:hive_flutter/hive_flutter.dart';

class ServerDB {
  static const String SERVER_URL_BUCKET_NAME = 'sse_service_url';
  static const String DEVICE_NAME_BUCKET_NAME = 'device_name';
  static final _myBox = Hive.box('app_settings');

  static String? _serverUrl;
  static String? _selectedDevice;

  static String? getPublishUrl() {
    _serverUrl ??= _myBox.get(SERVER_URL_BUCKET_NAME);
    if (_serverUrl != null &&
        _serverUrl?.isEmpty == false &&
        _selectedDevice != null &&
        _selectedDevice?.isEmpty == false) {
      return '$_serverUrl?deviceId=$_selectedDevice';
    }
    return null;
  }

  static String? getServerUrl() {
    _serverUrl ??= _myBox.get(SERVER_URL_BUCKET_NAME);
    return _serverUrl;
  }

  static String? getSelectedDevice() {
    _selectedDevice ??= _myBox.get(DEVICE_NAME_BUCKET_NAME);
    return _selectedDevice;
  }

  static String? getDevicesUrl() {
    _serverUrl ??= _myBox.get(SERVER_URL_BUCKET_NAME);
    return _serverUrl != null && _serverUrl?.isEmpty == false
        ? '$_serverUrl/devices'
        : null;
  }

  static void updateSubscriptionUrl(String? newUrl) {
    _myBox.put(SERVER_URL_BUCKET_NAME, newUrl);
    _serverUrl = newUrl;
  }

  static void updateTargetDeviceName(String? newDeviceName) {
    _myBox.put(DEVICE_NAME_BUCKET_NAME, newDeviceName);
    _selectedDevice = newDeviceName;
  }
}
