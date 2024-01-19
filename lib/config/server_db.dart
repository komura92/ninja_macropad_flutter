import 'package:hive_flutter/hive_flutter.dart';

class ServerDB {
  static final _myBox = Hive.box('app_settings');

  static String? getSubscriptionUrl() {
    return _myBox.get('subscription_url');
  }

  static void updateSubscriptionUrl(String? newUrl) {
    _myBox.put('subscription_url', newUrl);
  }
}