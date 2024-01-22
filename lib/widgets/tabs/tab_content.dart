import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/data/db/menu_config_db.dart';

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
      child: ReorderableGridView.count(
        childAspectRatio: 1.0,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        crossAxisCount: itemsPerRow,
        onReorder: (int oldIndex, int newIndex) {
          if ((oldIndex != widget.actions.length - 1) &&
              (newIndex != widget.actions.length - 1)) {
            ActionPanel movingPanel = widget.actions.removeAt(oldIndex);
            widget.actions.insert(newIndex, movingPanel);
            MenuConfigDB.saveActionsForMenuOption(
                widget.menuIdentifier, widget.actions);
            setState(() {});
          }
        },
        children: widget.actions
            .map((action) => Padding(
                  key: ValueKey(action.actionExecutor),
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                      onTap: () {
                        if (widget.actions.indexOf(action) !=
                            widget.actions.length - 1) {
                          SseClient.callAction(action.actionExecutor);
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
                            InkWell(
                              onTap: () {
                                showActionPanelPopupMenu(action);
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
                            ),
                            Container(
                              child: action.actionIcon,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,15,0,0),
                              child: Center(
                                  child: Text(
                                action.actionName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.amber),
                              )),
                            )
                          ],
                        ),
                      )),
                ))
            .toList(),
      ),
    );
  }

  void saveAction(ActionPanel action) {
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
    MenuConfigDB.saveActionsForMenuOption(
        widget.menuIdentifier, widget.actions);
  }
}
