import 'package:flutter/material.dart';

class ActionPanel {
  String actionName;
  Widget actionIcon;
  String actionExecutor;

  ActionPanel(
      {required this.actionName,
      required this.actionIcon,
      required this.actionExecutor});
}
