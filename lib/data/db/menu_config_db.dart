import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/data/mapper/menu_config_mapper.dart';
import 'package:hive/hive.dart';

import '../model/menu_config.dart';

// todo | UI for menu options configuration (delete left)
// todo | on removing menu option from DB also remember to delete it's actions
class MenuConfigDB {
  static const String _menuConfigBoxName = 'menu_config';
  static final _menuConfigBox = Hive.box(_menuConfigBoxName);

  static final List<MenuConfig> _menuConfigCache = [];

  static void saveMenuConfig(List<MenuConfig> menuConfig) {
    _menuConfigBox.put(
        _menuConfigBoxName, MenuConfigMapper.getAsListOfMaps(menuConfig));

    // todo check deleted and remove unnecessary actions config
    _updateCache(menuConfig);
  }

  static void _updateCache(List<MenuConfig> menuConfig) {
    _menuConfigCache.clear();
    _menuConfigCache.addAll(menuConfig);
  }

  static List<MenuConfig> getMenuConfig() {
    if (_menuConfigCache.isNotEmpty) {
      return List.of(_menuConfigCache);
    }
    List<MenuConfig>? savedMenuConfig = _getMenuConfigFromBoxDB();
    if (savedMenuConfig == null || savedMenuConfig.isEmpty) {
      List<MenuConfig> initialList = _getDefaultMenuConfig();
      _updateCache(initialList);
      return initialList;
    }
    _updateCache(savedMenuConfig);
    return savedMenuConfig;
  }

  static List<MenuConfig>? _getMenuConfigFromBoxDB() {
    List? menuConfigs = _menuConfigBox.get(_menuConfigBoxName);
    return MenuConfigMapper.toMenuConfigs(menuConfigs);
  }

  static List<MenuConfig> _getDefaultMenuConfig() {
    return List.of([
      MenuConfig(
          menuLabel: 'Programming',
          menuIdentifier: 'PROGRAMMING',
          menuIcon: Icons.developer_mode),
      MenuConfig(
          menuLabel: 'Gaming',
          menuIdentifier: 'GAMING',
          menuIcon: Icons.sports_esports),
      MenuConfig(
          menuLabel: 'Desktop',
          menuIdentifier: 'DESKTOP',
          menuIcon: Icons.desktop_windows),
      MenuConfig(
          menuLabel: null,
          menuIdentifier: "ADD_MENU_ITEM",
          menuIcon: Icons.add_circle_outline_rounded)
    ]);
  }
}
