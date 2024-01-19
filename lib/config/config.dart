import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/config/model/action_panel.dart';

import 'model/menu_config.dart';

class Config {
  static List<MenuConfig> getMenuConfig() {
    return List.of([
      MenuConfig(
          menuLabel: 'Programmer',
          menuIcon: Icons.developer_mode,
          actionPanels: [
            ActionPanel(
                actionName: 'Switch case',
                actionIcon: 'switchcase.png',
                actionExecutor: 'SWITCH_CASE_SHORTCUT'),
            ActionPanel(
                actionName: 'CRUD',
                actionIcon: 'crud.png',
                actionExecutor: 'GENERATE_CRUD'),
            ActionPanel(
                actionName: 'Stacktrace',
                actionIcon: 'stacktrace.png',
                actionExecutor: 'ANALYZE_STACKTRACE'),
            ActionPanel(
                actionName: 'Evaluator',
                actionIcon: 'evaluator.png',
                actionExecutor: 'EVALUATOR_SHORTCUT'),
            ActionPanel(
                actionName: 'MVN build',
                actionIcon: 'build.png',
                actionExecutor: 'MVN_BUILD'),
            ActionPanel(
                actionName: 'Deploy',
                actionIcon: 'deploy.png',
                actionExecutor: 'DEV_DEPLOY_SCRIPT')
          ]),
      MenuConfig(
          menuLabel: 'Gaming',
          menuIcon: Icons.sports_esports,
          actionPanels: [
            ActionPanel(
                actionName: 'Chrome',
                actionIcon: 'chrome.png',
                actionExecutor: 'RUN_CHROME'),
            ActionPanel(
                actionName: 'CS2',
                actionIcon: 'cs.jpg',
                actionExecutor: 'RUN_CS'),
            ActionPanel(
                actionName: 'Discord',
                actionIcon: 'discord.png',
                actionExecutor: 'RUN_DISCORD'),
            ActionPanel(
                actionName: 'Steam',
                actionIcon: 'steam.png',
                actionExecutor: 'RUN_STEAM'),
            ActionPanel(
                actionName: 'Accept',
                actionIcon: 'accept.jpg',
                actionExecutor: 'CLICK_ACCEPT')
          ]),
      MenuConfig(
          menuLabel: 'Desktop',
          menuIcon: Icons.desktop_windows,
          actionPanels: [
            ActionPanel(
                actionName: 'IntelliJ',
                actionIcon: 'ij.png',
                actionExecutor: 'RUN_INTELLIJ'),
            ActionPanel(
                actionName: 'PyCharm',
                actionIcon: 'pycharm.png',
                actionExecutor: 'RUN_PYCHARM'),
            ActionPanel(
                actionName: 'Android Studio',
                actionIcon: 'android_studio.png',
                actionExecutor: 'RUN_ANDROID_STUDIO'),
            ActionPanel(
                actionName: 'Chrome',
                actionIcon: 'chrome.png',
                actionExecutor: 'RUN_CHROME'),
            ActionPanel(
                actionName: 'Explorer',
                actionIcon: 'explorer.png',
                actionExecutor: 'RUN_EXPLORER'),
            ActionPanel(
                actionName: 'Terminal',
                actionIcon: 'terminal.png',
                actionExecutor: 'RUN_TERMINAL')
          ])
    ]);
  }
}
