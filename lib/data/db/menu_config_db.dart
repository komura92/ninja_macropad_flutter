import 'package:flutter/material.dart';

import 'package:flutter_ninja_macropad/data/model/action_panel.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MenuConfigDB {
  static final _myBox = Hive.box('menu_config_actions');

  static final Map<String, List<ActionPanel>> _actionsByMenuIdentifiers = {};

  static final _defaultActionPanel = ActionPanel(
      actionName: 'Add',
      actionIcon: Icon(
        Icons.add,
        size: 80,
        color: Colors.grey.shade500,
      ),
      actionExecutor: '');

  static void saveActionsForMenuOption(
      String menuOption, List<ActionPanel> actions) {
    _myBox.put(menuOption, _getAsListOfMaps(actions));

    _actionsByMenuIdentifiers.update(menuOption, (value) => actions,
        ifAbsent: () => actions);
  }

  static List<ActionPanel> getActionsForMenuOption(String menuOption) {
    if (_isCacheLoaded(menuOption)) {
      return _getFromCache(menuOption);
    } else {
      List<ActionPanel>? savedActions = _getActionsFromBoxDB(menuOption);
      if (savedActions == null || savedActions.isEmpty) {
        List<ActionPanel> initialList = _defaultInitialList();
        _updateCache(menuOption, initialList);
        return initialList;
      }
      _updateCache(menuOption, savedActions);
      return savedActions;
    }
  }

  static List<ActionPanel> _getFromCache(String menuOption) =>
      _actionsByMenuIdentifiers[menuOption]!;

  static bool _isCacheLoaded(String menuOption) =>
      _actionsByMenuIdentifiers.containsKey(menuOption);

  static List<ActionPanel> _updateCache(
      String menuOption, List<ActionPanel> actions) {
    return _actionsByMenuIdentifiers.update(menuOption, (value) => actions,
        ifAbsent: () => actions);
  }

  static List<ActionPanel>? _getActionsFromBoxDB(String menuOption) {
    List? savedActions = _myBox.get(menuOption);
    if (savedActions == null) {
      return null;
    }
    List<ActionPanel> actions = List.of([]);
    for (var action in savedActions) {
      actions.add(ActionPanel(
          actionName: action['actionName'] as String,
          actionIcon: action['actionIconType'] == 'ICON'
              ? Icon(
                  IconData(action['actionIcon'] as int,
                      fontFamily: 'MaterialIcons'),
                  size: 80,
                  color: Colors.grey.shade500,
                )
              : Image.asset(
                  action['actionIcon'] as String,
                  height: 80,
                ),
          actionExecutor: action['actionExecutor'] as String));
    }
    return actions;
  }

  static List<Map<String, dynamic>> _getAsListOfMaps(
      List<ActionPanel> actions) {
    List<Map<String, dynamic>> mapped = List.of([]);
    for (var action in actions) {
      mapped.add({
        'actionName': action.actionName,
        'actionIconType': action.actionIcon is Icon ? 'ICON' : 'IMAGE',
        'actionIcon': action.actionIcon is Icon
            ? (action.actionIcon as Icon).icon?.codePoint
            : ((action.actionIcon as Image).image as AssetImage).assetName,
        'actionExecutor': action.actionExecutor
      });
    }
    return mapped;
  }

  static List<ActionPanel> _defaultInitialList() =>
      List.of([_defaultActionPanel]);
}