import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/widgets/settings/dialog_button.dart';


class SettingsDialog extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  SettingsDialog({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade800,
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              style: TextStyle(color: Colors.grey.shade300),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: Colors.grey.shade300),
                hintText: "Server subscribe URL",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DialogButton(text: "Save", onPressed: onSave),
                const SizedBox(width: 8),
                DialogButton(text: "Cancel", onPressed: onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}