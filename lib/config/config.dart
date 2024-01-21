import 'package:flutter/material.dart';

import '../data/model/menu_config.dart';

// todo | remove this file and store menu options config in Hive
// todo | UI for menu options configuration
// todo | on removing menu option from DB also remember to delete it's actions
class Config {
  static List<MenuConfig> getMenuConfig() {
    return List.of([
      MenuConfig(
          menuLabel: 'Programming',
          menuIdentifier: 'PROGRAMMING',
          menuIcon: Icons.developer_mode),
      MenuConfig(
          menuLabel: 'Gaming',
          menuIdentifier: 'GAMING',
          menuIcon: Icons.sports_esports
    ),
      MenuConfig(
          menuLabel: 'Desktop',
          menuIdentifier: 'DESKTOP',
          menuIcon: Icons.desktop_windows)
    ]);
  }
}
