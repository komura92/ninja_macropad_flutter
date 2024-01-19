import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/config/config.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomMenuWidget extends StatelessWidget {
  final void Function(dynamic index) onTabChange;

  const BottomMenuWidget({
    super.key,
    required this.onTabChange,
  });

  static List<GButton> menuButtons = Config.getMenuConfig().map((menuConfig) => GButton(
    icon: menuConfig.menuIcon,
    text: menuConfig.menuLabel,
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
