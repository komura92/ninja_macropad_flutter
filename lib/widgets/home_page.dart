import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/data/db/server_db.dart';
import 'package:flutter_ninja_macropad/data/model/menu_config.dart';

import 'package:flutter_ninja_macropad/widgets/menu/bottom_menu.dart';
import 'package:flutter_ninja_macropad/widgets/settings/menu_config/menu_settings_dialog.dart';
import 'package:flutter_ninja_macropad/widgets/settings/menu_config/settings_context_popup_menu.dart';
import 'package:flutter_ninja_macropad/widgets/tabs/tab_content.dart';
import 'package:flutter_ninja_macropad/widgets/settings/connection/connection_settings_dialog.dart';

import '../data/db/menu_config_db.dart';
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

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenuWidget(onTabChange: updateSelectedIndex),
      body: TabContent.fromMenuIdentifier(
          menuIdentifier:
              MenuConfigDB.getMenuConfig()[selectedIndex].menuIdentifier!),
      floatingActionButton: FloatingActionButton(
        onPressed: showSettingsContextMenuPopup,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.settings, color: Colors.black),
      ),
    );
  }

  void showConnectionSettingsPopup() {
    SseClient.getAvailableDevices(context).then((availableDevices) {
      if (!availableDevices.contains(_selectedDeviceController.text)) {
        _selectedDeviceController.text = "";
      }
      showDialog(
        context: context,
        builder: (context) {
          return ConnectionSettingsDialog(
            serverUrlController: _serverUrlController,
            selectedDeviceController: _selectedDeviceController,
            onSave: updateConnectionSettings,
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

  void showSettingsContextMenuPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return MenuSettingsPanelPopupMenu(
          showConnectionSettingsPopup: showConnectionSettingsPopup,
          showMenuConfigOverlay: showMenuSettingsPopup,
        );
      },
    );
  }

  void showMenuSettingsPopup() {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6),
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, __, ___) {
        return MenuSettingsDialog(
          onSave: updateMenuSettings,
          menuItems: MenuConfigDB.getMenuConfig(),
        );
      },
    );
  }

  void updateConnectionSettings() {
    ServerDB.updateTargetDeviceName(_selectedDeviceController.text);
    ServerDB.updateSubscriptionUrl(_serverUrlController.text);
    Navigator.of(context).pop();
  }

  void updateMenuSettings(List<MenuConfig> menuItems) {
    MenuConfigDB.saveMenuConfig(menuItems);
  }
}
