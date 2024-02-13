import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/data/db/menu_actions_db.dart';

import 'package:flutter_ninja_macropad/widgets/tabs/popups/action_form_dialog.dart';
import 'package:flutter_ninja_macropad/widgets/tabs/popups/action_context_popup_menu.dart';
import 'package:flutter_ninja_macropad/widgets/tabs/popups/delete_action_popup.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../data/client/sse_client.dart';
import '../../data/model/action_panel.dart';

class TabContent extends StatefulWidget {
  final String menuIdentifier;
  final List<ActionPanel> actions;

  TabContent.fromMenuIdentifier({super.key, required this.menuIdentifier})
      : actions = MenuActionsDB.getActionsForMenuIdentifier(menuIdentifier);

  @override
  State<TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  void showActionFormPopup(ActionPanel? action) {
    showDialog(
      context: context,
      builder: (context) {
        return ActionFormDialog(
          actionSave: saveAction,
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
        child: ReorderableGridView.builder(
          itemBuilder: (context, index) {
            return Padding(
              key: ValueKey(widget.actions[index].actionExecutor),
              padding: const EdgeInsets.all(8),
              child: InkWell(
                  onTap: () {
                    if (index != widget.actions.length - 1) {
                      SseClient.callAction(
                          widget.actions[index].actionExecutor, context);
                    } else {
                      showActionFormPopup(null);
                    }
                  },
                  borderRadius: BorderRadius.circular(36),
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        boxShadow: const [
                          BoxShadow(
                              // color: Colors.black,
                              spreadRadius: 1,
                              blurRadius: 7)
                        ],
                        borderRadius: BorderRadius.circular(36)),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        index != widget.actions.length - 1
                            ? InkWell(
                                onTap: () {
                                  showActionPanelPopupMenu(
                                      widget.actions[index]);
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 10, 0),
                                    child: Icon(
                                      Icons.more_vert,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 30,
                              ),
                        Container(
                          child: widget.actions[index].actionIcon,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Center(
                              child: Text(
                            widget.actions[index].actionName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.amber),
                          )),
                        )
                      ],
                    ),
                  )),
            );
          },
          itemCount: widget.actions.length,
          onReorder: (int oldIndex, int newIndex) {
            if ((oldIndex != widget.actions.length - 1) &&
                (newIndex != widget.actions.length - 1)) {
              setState(() {
                ActionPanel movingPanel = widget.actions.removeAt(oldIndex);
                widget.actions.insert(newIndex, movingPanel);
                MenuActionsDB.saveActionsForMenuIdentifier(
                    widget.menuIdentifier, widget.actions);
              });
            }
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: itemsPerRow),
        ));
  }

  void saveAction(ActionPanel action) {
    setState(() {
      if (!widget.actions.contains(action)) {
        widget.actions.insert(widget.actions.length - 1, action);
      }
      MenuActionsDB.saveActionsForMenuIdentifier(
          widget.menuIdentifier, widget.actions);
    });
  }

  onDelete(ActionPanel? action) {
    if (action != null) {
      setState(() {
        widget.actions.remove(action);
      });
    }
    MenuActionsDB.saveActionsForMenuIdentifier(
        widget.menuIdentifier, widget.actions);
  }
}
