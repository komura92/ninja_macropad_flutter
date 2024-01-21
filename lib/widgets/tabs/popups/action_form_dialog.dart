import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import 'package:flutter_ninja_macropad/widgets/settings/dialog_button.dart';
import '../../../data/model/action_panel.dart';


class ActionFormDialog extends StatefulWidget {
  final Function(ActionPanel action) actionSave;
  final ActionPanel? initialAction;

  const ActionFormDialog(
      {super.key, required this.actionSave, required this.initialAction});

  @override
  State<ActionFormDialog> createState() => _ActionFormDialogState();
}

class _ActionFormDialogState extends State<ActionFormDialog> {
  final actionNameController = TextEditingController(text: '');
  final actionCommandController = TextEditingController(text: '');
  IconData? _icon;
  String? actionLabel;
  String? actionCommand;

  openIconPicker() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.cupertino], adaptiveDialog: true);

    if (icon != null) {
      // _icon = icon;
      setState(() {
        _icon = icon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _icon ??= widget.initialAction?.actionIcon is Icon
        ? (widget.initialAction?.actionIcon as Icon).icon
        : null;
    var actionName = widget.initialAction?.actionName;
    if (actionName != null && actionNameController.text.isEmpty) {
      actionNameController.text = actionName;
    }
    var actionCommand = widget.initialAction?.actionExecutor;
    if (actionCommand != null && actionCommandController.text.isEmpty) {
      actionCommandController.text = actionCommand;
    }
    return AlertDialog(
      title: Text(
        widget.initialAction == null ? 'Create new action' : 'Edit action',
        style: TextStyle(color: Colors.grey.shade300),
      ),
      backgroundColor: Colors.blue.shade800,
      content: SizedBox(
        height: 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: actionNameController,
              cursorColor: Colors.grey.shade300,
              style: TextStyle(color: Colors.grey.shade300),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade300),
                hintText: "Action label",
                suffixIcon: IconButton(
                  onPressed: actionNameController.clear,
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            TextField(
              controller: actionCommandController,
              cursorColor: Colors.grey.shade300,
              style: TextStyle(color: Colors.grey.shade300),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade300),
                hintText: "Action command",
                suffixIcon: IconButton(
                  onPressed: actionCommandController.clear,
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            Ink(
              child: InkWell(
                onTap: () {
                  openIconPicker();
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade600)),
                  child: _icon != null
                      ? Icon(
                          _icon,
                          color: Colors.grey.shade500,
                        )
                      : Text(
                          'No icon selected',
                          style: TextStyle(color: Colors.grey.shade300),
                        ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DialogButton(text: "Save", onPressed: onSave),
                const SizedBox(width: 8),
                DialogButton(text: "Cancel", onPressed: onCancel)
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onSave() {
    ActionPanel action;

    if (widget.initialAction == null) {
      action = getNewActionPanel();
    } else {
      updateActualData();
      action = widget.initialAction!;
    }
    widget.actionSave(action);
    Navigator.of(context).pop();
  }

  ActionPanel getNewActionPanel() {
    return ActionPanel(
        actionName: actionNameController.text,
        actionIcon: Icon(
          _icon,
          color: Colors.grey.shade500,
          size: 80,
        ),
        actionExecutor: actionCommandController.text);
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  void updateActualData() {
    widget.initialAction?.actionName = actionNameController.text;
    widget.initialAction?.actionExecutor = actionCommandController.text;

    if (_icon != null) {
      widget.initialAction?.actionIcon = Icon(
        _icon,
        color: Colors.grey.shade500,
        size: 80,
      );
    }
  }
}
