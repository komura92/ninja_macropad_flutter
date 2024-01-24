import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_ninja_macropad/widgets/settings/dialog_button.dart';

import '../../../data/model/menu_config.dart';

class MenuSettingsDialog extends StatefulWidget {
  final Function(List<MenuConfig> menuItems) onSave;
  final List<MenuConfig> menuItems;

  const MenuSettingsDialog(
      {super.key, required this.onSave, required this.menuItems});

  @override
  State<MenuSettingsDialog> createState() => _MenuSettingsDialogState();
}

class _MenuSettingsDialogState extends State<MenuSettingsDialog> {
  final List<TextEditingController> _menuLabelControllers = [];
  final List<TextEditingController> _menuIdentifierControllers = [];
  final List<IconData?> _icons = [];

  _openIconPicker(index) async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material], adaptiveDialog: true);

    if (icon != null) {
      setState(() {
        _icons[index] = icon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.black87,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Text(
                  'Menu settings',
                  style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 26,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: ReorderableListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      _menuLabelControllers.add(TextEditingController(
                          text: widget.menuItems[index].menuLabel));
                      _menuIdentifierControllers.add(TextEditingController(
                          text: widget.menuItems[index].menuIdentifier));
                      _icons.add(widget.menuItems[index].menuIcon);
                      return Padding(
                        key: ValueKey(widget.menuItems[index].menuIdentifier),
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 1,
                                    blurRadius: 7)
                              ],
                              borderRadius: BorderRadius.circular(36)),
                          child: Column(
                            children: index != widget.menuItems.length - 1
                                ? getContentForMenuItem(index)
                                : getItemsForAddButton(index),
                          ),
                        ),
                      );
                    },
                    itemCount: widget.menuItems.length,
                    onReorder: reorderMenuConfigListAndPropagate,
                  )),
              const SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DialogButton(text: "Save", onPressed: onSave),
                    const SizedBox(width: 15),
                    DialogButton(
                        text: "Cancel",
                        onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  MenuConfig propagateRemoveMenuConfig(int oldIndex) {
    return widget.menuItems.removeAt(oldIndex);
  }

  List<Widget> getItemsForAddButton(int index) {
    return [
      Ink(
        child: InkWell(
          onTap: () {
            setState(() {
              appendNewMenuConfig(index);
            });
          },
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: _icons[index] != null
                ? Icon(
                    _icons[index],
                    color: Colors.grey.shade500,
                  )
                : Text(
                    'No icon selected',
                    style: TextStyle(color: Colors.grey.shade300),
                  ),
          ),
        ),
      )
    ];
  }

  void appendNewMenuConfig(int index) {
    IconData newIconDefault = Icons.question_mark;
    MenuConfig config = MenuConfig(
        menuLabel: null, menuIdentifier: null, menuIcon: newIconDefault);
    propagateMenuConfigInsert(index, config);
  }

  void propagateMenuConfigInsert(int index, MenuConfig config) {
    widget.menuItems.insert(index, config);

    _menuLabelControllers.insert(
        index, TextEditingController(text: config.menuLabel ?? ''));
    _menuIdentifierControllers.insert(
        index, TextEditingController(text: config.menuIdentifier ?? ''));
    _icons.insert(index, config.menuIcon);
  }

  List<Widget> getContentForMenuItem(int index) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: TextField(
          controller: _menuLabelControllers[index],
          style: TextStyle(color: Colors.grey.shade300),
          decoration: InputDecoration(
            hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade300,
                fontWeight: FontWeight.normal),
            hintText: "Menu label",
            suffixIcon: IconButton(
              onPressed: _menuLabelControllers[index].clear,
              icon: Icon(
                Icons.clear,
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 15),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextField(
            controller: _menuIdentifierControllers[index],
            style: TextStyle(color: Colors.grey.shade300),
            decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.normal),
              hintText: "Menu identifier",
              suffixIcon: IconButton(
                onPressed: _menuIdentifierControllers[index].clear,
                icon: Icon(
                  Icons.clear,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          )),
      const SizedBox(
        height: 15,
      ),
      Ink(
        child: InkWell(
          onTap: () {
            _openIconPicker(index);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade600),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: _icons[index] != null
                ? Icon(
                    _icons[index],
                    color: Colors.grey.shade500,
                  )
                : Text(
                    'No icon selected',
                    style: TextStyle(color: Colors.grey.shade300),
                  ),
          ),
        ),
      )
    ];
  }

  void onSave() {
    for (int i = 0; i < widget.menuItems.length - 1; i++) {
      widget.menuItems[i].menuIcon = _icons[i]!;
      widget.menuItems[i].menuIdentifier = _menuIdentifierControllers[i].text;
      widget.menuItems[i].menuLabel = _menuLabelControllers[i].text;
    }

    widget.onSave(widget.menuItems);
    Navigator.of(context).pop();
  }

  void reorderMenuConfigListAndPropagate(int oldIndex, int newIndex) {
    if (oldIndex != widget.menuItems.length - 1 &&
        newIndex != widget.menuItems.length) {
      setState(() {
        propagateMoveMenuConfig(oldIndex, newIndex);
      });
    }
  }

  void propagateMoveMenuConfig(int oldIndex, int newIndex) {
    int targetIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;

    // move config
    MenuConfig config = widget.menuItems.removeAt(oldIndex);
    widget.menuItems.insert(targetIndex, config);

    // move text controllers
    TextEditingController menuLabelController =
        _menuLabelControllers.removeAt(oldIndex);
    TextEditingController menuIdentifierController =
        _menuIdentifierControllers.removeAt(oldIndex);
    _menuLabelControllers.insert(targetIndex, menuLabelController);
    _menuIdentifierControllers.insert(targetIndex, menuIdentifierController);

    // move icon
    IconData? icon = _icons.removeAt(oldIndex);
    _icons.insert(targetIndex, icon);
  }
}
