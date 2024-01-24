import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_ninja_macropad/data/model/action_panel.dart';

class ActionMapper {

  static List<ActionPanel>? toActionPanels(actionsMaps) {
    if (actionsMaps == null) {
      return null;
    }
    List<ActionPanel> actions = [];
    for (var action in actionsMaps) {
      actions.add(ActionPanel(
          actionName: action['actionName'] as String,
          actionIcon: _getIconForAction(action),
          actionExecutor: action['actionExecutor'] as String));
    }
    return actions;
  }

  static List<Map<String, dynamic>> getAsListOfMaps(
      List<ActionPanel> actions) {
    List<Map<String, dynamic>> mapped = [];
    for (var action in actions) {
      mapped.add({
        'actionName': action.actionName,
        'actionIconType': action.actionIcon is Icon ? 'ICON' : 'IMAGE',
        'actionIcon': _getActionIconForSave(action),
        'actionExecutor': action.actionExecutor
      });
    }
    return mapped;
  }

  static Widget? _getIconForAction(action) {
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

  static Object? _getActionIconForSave(ActionPanel action) {
    if (action.actionIcon == null) {
      return null;
    }
    return action.actionIcon is Icon
        ? (action.actionIcon as Icon).icon?.codePoint
        : ((action.actionIcon as Image).image as FileImage).file.path;
  }
}