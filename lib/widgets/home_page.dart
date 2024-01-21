import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/data/db/server_db.dart';

import 'package:flutter_ninja_macropad/widgets/menu/bottom_menu.dart';
import 'package:flutter_ninja_macropad/widgets/tabs/tab_content.dart';
import 'package:flutter_ninja_macropad/widgets/settings/settings_dialog.dart';

import '../config/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final _controller =
      TextEditingController(text: ServerDB.getSubscriptionUrl());

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
    showDialog(
      context: context,
      builder: (context) {
        return SettingsDialog(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () {
            Navigator.of(context).pop();
            _controller.text = ServerDB.getSubscriptionUrl() != null
                ? ServerDB.getSubscriptionUrl()!
                : '';
          },
        );
      },
    );
  }

  void saveNewTask() {
    ServerDB.updateSubscriptionUrl(_controller.text);
    Navigator.of(context).pop();
  }
}
