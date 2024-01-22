import 'package:flutter/material.dart';

import '../../../data/model/action_panel.dart';

class ActionPanelPopupMenu extends StatelessWidget {
  final Function(ActionPanel? _) onEdit;
  final Function(ActionPanel? _) onDelete;
  final ActionPanel? action;

  const ActionPanelPopupMenu(
      {super.key,
      required this.onEdit,
      required this.onDelete,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade800,
      content: Container(
        height: 141,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                onEdit(action);
              },
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Edit',
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 22),
                      ),
                    ],
                  )),
            ),
            Divider(
              color: Colors.grey.shade300,
              height: 1,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                onDelete(action);
              },
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Delete',
                      style:
                          TextStyle(color: Colors.grey.shade300, fontSize: 22),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
