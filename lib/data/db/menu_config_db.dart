import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_ninja_macropad/data/model/action_panel.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MenuConfigDB {
  static final _myBox = Hive.box('menu_config_actions');

  static final Map<String, List<ActionPanel>> _actionsByMenuIdentifiers = {};

  static final _defaultActionPanel = ActionPanel(
      actionName: 'Add',
      actionIcon: Icon(
        CupertinoIcons.add_circled,
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
          actionIcon: getIconForAction(action),
          actionExecutor: action['actionExecutor'] as String));
    }
    return actions;
  }

  static Widget? getIconForAction(action) {
    if (action['actionIcon'] == null) {
      return null;
    }
    return action['actionIconType'] == 'ICON'
            ? Icon(
                IconData(action['actionIcon'] as int,
                    fontFamily: 'CupertinoIcons',
                fontPackage: 'cupertino_icons'),
                size: 80,
                color: Colors.grey.shade500,
              )
            : Image.file(
                File(action['actionIcon'] as String),
                height: 80,
              );
  }

  static List<Map<String, dynamic>> _getAsListOfMaps(
      List<ActionPanel> actions) {
    List<Map<String, dynamic>> mapped = List.of([]);
    for (var action in actions) {
      mapped.add({
        'actionName': action.actionName,
        'actionIconType': action.actionIcon is Icon ? 'ICON' : 'IMAGE',
        'actionIcon': getActionIconForSave(action),
        'actionExecutor': action.actionExecutor
      });
    }
    return mapped;
  }

  static Object? getActionIconForSave(ActionPanel action) {
    if (action.actionIcon == null) {
      return null;
    }
    return action.actionIcon is Icon
          ? (action.actionIcon as Icon).icon?.codePoint
          : ((action.actionIcon as Image).image as FileImage).file.path;
  }

  static List<ActionPanel> _defaultInitialList() =>
      List.of([_defaultActionPanel]);
}
