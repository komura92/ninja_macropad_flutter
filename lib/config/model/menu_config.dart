import 'package:flutter/material.dart';

import 'action_panel.dart';

class MenuConfig {
  final String menuLabel;
  final IconData menuIcon;
  final List<ActionPanel> actionPanels;

  MenuConfig({
    required this.menuLabel,
    required this.menuIcon,
    required this.actionPanels
  });
}