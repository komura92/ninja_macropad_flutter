import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/widgets/menu/bottom_menu.dart';
import 'package:flutter_ninja_macropad/widgets/tab_content.dart';

import 'config/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;

  void updateSelectedIndex(dynamic index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomMenuWidget(onTabChange: updateSelectedIndex),
          body: TabContent(actions: Config.getMenuConfig()[selectedIndex].actionPanels),
        )
    );
  }
}
