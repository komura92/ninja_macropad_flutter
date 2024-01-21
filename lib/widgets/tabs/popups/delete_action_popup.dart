import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/widgets/settings/dialog_button.dart';

import '../../../data/model/action_panel.dart';

class DeleteActionPopup extends StatelessWidget {
  Function(ActionPanel action) onDelete;
  ActionPanel action;

  DeleteActionPopup({
    super.key,
    required this.onDelete,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirmation',
        style: TextStyle(
          color: Colors.grey.shade300,
        ),
      ),
      backgroundColor: Colors.blue.shade800,
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                'Do you really want to delete action "${action.actionName}"?',
              style: TextStyle(
        color: Colors.grey.shade300,
        ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    onDelete(action);
                    Navigator.of(context).pop();
                  },
                  color: Colors.red.shade500,
                  child:
                      Text("Delete", style: TextStyle(color: Colors.grey.shade300)),
                ),
                const SizedBox(width: 8),
                DialogButton(
                    text: "Cancel",
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
