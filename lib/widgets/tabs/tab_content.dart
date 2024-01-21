import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/data/db/menu_config_db.dart';

import 'package:flutter_ninja_macropad/widgets/tabs/popups/action_form_dialog.dart';
import 'package:flutter_ninja_macropad/widgets/tabs/popups/action_context_popup_menu.dart';
import 'package:flutter_ninja_macropad/widgets/tabs/popups/delete_action_popup.dart';

import '../../data/client/sse_client.dart';
import '../../data/model/action_panel.dart';

class TabContent extends StatefulWidget {
  final String menuIdentifier;
  final List<ActionPanel> actions;

  TabContent.fromMenuIdentifier({super.key, required this.menuIdentifier})
      : actions = MenuConfigDB.getActionsForMenuOption(menuIdentifier);

  @override
  State<TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  void showActionFormPopup(ActionPanel? action) {
    showDialog(
      context: context,
      builder: (context) {
        return ActionFormDialog(
          actionSave: addAction,
          initialAction: action,
        );
      },
    );
  }

  void showActionPanelPopupMenu(ActionPanel? action) {
    showDialog(
      context: context,
      builder: (context) {
        return ActionPanelPopupMenu(
          action: action,
          onDelete: showActionPanelDeletePopup,
          onEdit: showActionFormPopup,
        );
      },
    );
  }

  void showActionPanelDeletePopup(ActionPanel? action) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteActionPopup(
          action: action!,
          onDelete: onDelete,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int itemsPerRow =
        MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4;
    return Container(
      color: Colors.black87,
      child: GridView.builder(
          itemCount: widget.actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: itemsPerRow),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                  onTap: () {
                    if (index != widget.actions.length - 1) {
                      SseClient.callAction(
                          widget.actions[index].actionExecutor);
                    } else {
                      showActionFormPopup(null);
                    }
                  },
                  onLongPress: index != widget.actions.length - 1
                      ? () {
                          showActionPanelPopupMenu(widget.actions[index]);
                        }
                      : () {},
                  borderRadius: BorderRadius.circular(36),
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black,
                              spreadRadius: 1,
                              blurRadius: 7)
                        ],
                        borderRadius: BorderRadius.circular(36)),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: widget.actions[index].actionIcon,
                        ),
                        Center(
                            child: Text(
                          widget.actions[index].actionName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.amber),
                        ))
                      ],
                    ),
                  )),
            );
          }),
    );
  }

  void addAction(ActionPanel action) {
    setState(() {
      if (!widget.actions.contains(action)) {
        widget.actions.insert(widget.actions.length - 1, action);
      }
      MenuConfigDB.saveActionsForMenuOption(
          widget.menuIdentifier, widget.actions);
    });
  }

  onDelete(ActionPanel? action) {
    if (action != null) {
      setState(() {
        widget.actions.remove(action);
      });
    }
  }
}
