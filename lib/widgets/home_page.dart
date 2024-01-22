import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/data/db/server_db.dart';

import 'package:flutter_ninja_macropad/widgets/menu/bottom_menu.dart';
import 'package:flutter_ninja_macropad/widgets/tabs/tab_content.dart';
import 'package:flutter_ninja_macropad/widgets/settings/settings_dialog.dart';

import '../config/config.dart';
import '../data/client/sse_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final _serverUrlController =
      TextEditingController(text: ServerDB.getServerUrl());
  final _selectedDeviceController =
      TextEditingController(text: ServerDB.getSelectedDevice());

  void updateSelectedIndex(dynamic index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenuWidget(onTabChange: updateSelectedIndex),
      body: TabContent.fromMenuIdentifier(
          menuIdentifier: Config.getMenuConfig()[selectedIndex].menuIdentifier),
      floatingActionButton: FloatingActionButton(
        onPressed: showSettingsPopup,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.settings, color: Colors.black),
      ),
    );
  }

  void showSettingsPopup() {
    SseClient.getAvailableDevices(context).then((availableDevices) {
      showDialog(
        context: context,
        builder: (context) {
          return SettingsDialog(
            serverUrlController: _serverUrlController,
            selectedDeviceController: _selectedDeviceController,
            onSave: updateAppSettings,
            onCancel: () {
              Navigator.of(context).pop();
              _serverUrlController.text = ServerDB.getServerUrl() != null
                  ? ServerDB.getServerUrl()!
                  : '';
            },
            availableDevices: availableDevices,
          );
        },
      );
    });
  }

  void updateAppSettings() {
    ServerDB.updateDeviceName(_selectedDeviceController.text);
    ServerDB.updateSubscriptionUrl(_serverUrlController.text);
    Navigator.of(context).pop();
  }
}
