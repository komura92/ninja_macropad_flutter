import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/menu_config.dart';

class MenuConfigMapper {

  static List<MenuConfig>? toMenuConfigs(menuConfigsMaps) {
    if (menuConfigsMaps == null) {
      return null;
    }
    List<MenuConfig> mappedMenuConfigs = [];
    for (var menuConfig in menuConfigsMaps) {
      mappedMenuConfigs.add(MenuConfig(
          menuLabel: menuConfig['menuLabel'] as String?,
          menuIdentifier: menuConfig['menuIdentifier'] as String,
          menuIcon: _getIconForMenuItem(menuConfig)));
    }
    return mappedMenuConfigs;
  }

  static List<Map<String, dynamic>> getAsListOfMaps(
      List<MenuConfig> menuConfigs) {
    List<Map<String, dynamic>> mapped = [];
    for (var menuConfig in menuConfigs) {
      mapped.add({
        'menuLabel': menuConfig.menuLabel,
        'menuIdentifier': menuConfig.menuIdentifier,
        'menuIcon': menuConfig.menuIcon.codePoint,
      });
    }
    return mapped;
  }

  static IconData _getIconForMenuItem(menuConfig) {
    return IconData(menuConfig['menuIcon'] as int, fontFamily: 'MaterialIcons');
  }
}
