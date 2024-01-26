import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/utils/toast_utils.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:flutter_ninja_macropad/data/db/menu_config_db.dart';

import '../../data/client/sse_client.dart';
import '../../data/model/menu_config.dart';

class BottomMenuWidget extends StatefulWidget {
  final void Function(int index) onTabChange;

  const BottomMenuWidget({
    super.key,
    required this.onTabChange,
  });

  @override
  State<BottomMenuWidget> createState() => _BottomMenuWidgetState();
}

class _BottomMenuWidgetState extends State<BottomMenuWidget> {
  int selectedIndex = 0;

  static List<GButton> menuButtons = MenuConfigDB.getMenuConfig()
      .sublist(0, MenuConfigDB.getMenuConfig().length - 1)
      .map((menuConfig) => GButton(
            icon: menuConfig.menuIcon,
            text: menuConfig.menuLabel!,
          ))
      .toList();

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SseClient.updateSubscriptionCallback((event) {
      if (event.event == 'TAB_UPDATE') {
        Map<String, dynamic> data = json.decode(event.data!);
        try {
          MenuConfig menuConfig = MenuConfigDB.getMenuConfig().firstWhere(
              (config) => config.menuIdentifier == data['tabIdentifier']);
          updateSelectedIndex(MenuConfigDB.getMenuConfig().indexOf(menuConfig));
        } catch (ex) {
          ToastUtils.showToast(context, 'Unknown tab identifier');
        }
      }
    });
    return Container(
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
                selectedIndex: selectedIndex,
                backgroundColor: Colors.black,
                gap: 8,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey,
                padding: const EdgeInsets.all(12),
                onTabChange: (int index) {
                  widget.onTabChange(index);
                  selectedIndex = index;
                },
                tabs: menuButtons)));
  }
}
