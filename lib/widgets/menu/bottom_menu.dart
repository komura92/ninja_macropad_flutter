import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:flutter_ninja_macropad/data/db/menu_config_db.dart';

class BottomMenuWidget extends StatelessWidget {
  final void Function(dynamic index) onTabChange;

  const BottomMenuWidget({
    super.key,
    required this.onTabChange,
  });

  static List<GButton> menuButtons = MenuConfigDB.getMenuConfig().sublist(0, MenuConfigDB.getMenuConfig().length - 1).map((menuConfig) => GButton(
    icon: menuConfig.menuIcon,
    text: menuConfig.menuLabel!,
  )).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
                backgroundColor: Colors.black,
                gap: 8,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey,
                padding: const EdgeInsets.all(12),
                onTabChange: onTabChange,
                tabs: menuButtons)));
  }
}
