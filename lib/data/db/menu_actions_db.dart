import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_ninja_macropad/data/model/action_panel.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../mapper/action_mapper.dart';

class MenuActionsDB {
  static final _menuConfigActionsBox = Hive.box('menu_config_actions');

  static final Map<String, List<ActionPanel>> _actionsByMenuIdentifiersCache =
      {};

  static final _defaultActionPanel = ActionPanel(
      actionName: 'Add',
      actionIcon: Icon(
        CupertinoIcons.add_circled,
        size: 80,
        color: Colors.grey.shade500,
      ),
      actionExecutor: '');

  static void saveActionsForMenuIdentifier(
      String menuConfigIdentifier, List<ActionPanel> actions) {
    _menuConfigActionsBox.put(
        menuConfigIdentifier, ActionMapper.getAsListOfMaps(actions));

    _actionsByMenuIdentifiersCache.update(
        menuConfigIdentifier, (value) => actions,
        ifAbsent: () => actions);
  }

  static List<ActionPanel> getActionsForMenuIdentifier(String menuIdentifier) {
    if (_isInCache(menuIdentifier)) {
      return _getFromCache(menuIdentifier);
    } else {
      List<ActionPanel>? savedActions = _getActionsFromBoxDB(menuIdentifier);
      if (savedActions == null || savedActions.isEmpty) {
        List<ActionPanel> initialList = _defaultInitialList();
        _updateCache(menuIdentifier, initialList);
        return initialList;
      }
      _updateCache(menuIdentifier, savedActions);
      return savedActions;
    }
  }

  static List<ActionPanel> _getFromCache(String menuOption) =>
      _actionsByMenuIdentifiersCache[menuOption]!;

  static bool _isInCache(String menuOption) =>
      _actionsByMenuIdentifiersCache.containsKey(menuOption);

  static List<ActionPanel> _updateCache(
      String menuOption, List<ActionPanel> actions) {
    return _actionsByMenuIdentifiersCache.update(menuOption, (value) => actions,
        ifAbsent: () => actions);
  }

  static List<ActionPanel>? _getActionsFromBoxDB(String menuOption) {
    List? savedActions = _menuConfigActionsBox.get(menuOption);
    return ActionMapper.toActionPanels(savedActions);
  }

  static List<ActionPanel> _defaultInitialList() =>
      List.of([_defaultActionPanel]);

  static void deleteActions(String menuIdentifier) {
    _actionsByMenuIdentifiersCache.remove(menuIdentifier);
    _menuConfigActionsBox.delete(menuIdentifier);
  }
}
