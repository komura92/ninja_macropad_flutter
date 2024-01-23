import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import 'package:flutter_ninja_macropad/widgets/settings/dialog_button.dart';
import 'package:image_picker/image_picker.dart';
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
  static const MODES = ['Image', 'Icon'];
  final actionNameController = TextEditingController(text: '');
  final actionCommandController = TextEditingController(text: '');
  final ImagePicker imagePicker = ImagePicker();
  IconData? _icon;
  String? actionLabel;
  String? actionCommand;
  String? logoMode;
  String? _selectedImage;

  _openIconPicker() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.cupertino], adaptiveDialog: true);

    if (icon != null) {
      setState(() {
        _icon = icon;
      });
    }
  }

  Future<String?> _pickImageFromGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    return Future.value(image?.path);
  }

  @override
  Widget build(BuildContext context) {
    if (logoMode == null && widget.initialAction?.actionIcon is Icon) {
      logoMode = MODES[1];
    } else if (logoMode == null && widget.initialAction?.actionIcon is Image) {
      logoMode = MODES[0];
    }
    
    _icon ??= widget.initialAction?.actionIcon is Icon
        ? (widget.initialAction?.actionIcon as Icon).icon
        : null;
    _selectedImage ??= widget.initialAction?.actionIcon is Image
        ? ((widget.initialAction?.actionIcon as Image).image as FileImage).file.path
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
      content: SingleChildScrollView(
        child: SizedBox(
          height: 370,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: actionNameController,
                    cursorColor: Colors.grey.shade300,
                    style: TextStyle(color: Colors.grey.shade300),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                      hintText: "Action label",
                      suffixIcon: IconButton(
                        onPressed: actionNameController.clear,
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: actionCommandController,
                    cursorColor: Colors.grey.shade300,
                    style: TextStyle(color: Colors.grey.shade300),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                      hintText: "Action command",
                      suffixIcon: IconButton(
                        onPressed: actionCommandController.clear,
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade800,
                  hint: Text(
                    'Logo',
                    style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  value: logoMode,
                  icon: Icon(Icons.arrow_downward, color: Colors.grey.shade300),
                  elevation: 16,
                  style: TextStyle(color: Colors.grey.shade300),
                  onChanged: (String? value) {
                    setState(() {
                      logoMode = value;
                    });
                  },
                  items: MODES.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Container(
                child: logoMode == null ? null : getPickerForSelectedOption(),
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
      ),
    );
  }

  Ink getPickerForSelectedOption() {
    return logoMode == MODES[0]
        ? Ink(
      child: InkWell(
        onTap: () {
          _pickImageFromGallery().then((imagePath) {
            if (imagePath != null) {
              setState(() {
                this._selectedImage = imagePath;
              });
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade600)),
          child: _selectedImage != null
              ? getImageByPath(_selectedImage!)
              : Text(
            'No image selected',
            style: TextStyle(color: Colors.grey.shade300),
          ),
        ),
      ),
    )
        : Ink(
      child: InkWell(
        onTap: () {
          _openIconPicker();
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
    );
  }

  Image getImageByPath(String _selectedImage) {
    if (_selectedImage.startsWith('lib/assets/icons')) {
      return Image.asset(
        (_selectedImage),
        height: 80,
      );
    } else {
      return Image.file(
        File(_selectedImage),
        height: 30,
      );
    }
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
        actionIcon: getIconByWizardState(),
        actionExecutor: actionCommandController.text);
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  void updateActualData() {
    widget.initialAction?.actionName = actionNameController.text;
    widget.initialAction?.actionExecutor = actionCommandController.text;
    widget.initialAction?.actionIcon = getIconByWizardState();
  }

  Widget? getIconByWizardState() {
    if (logoMode == MODES[1] && _icon != null) {
      return Icon(
        _icon,
        color: Colors.grey.shade500,
        size: 80,
      );
    }

    if (logoMode == MODES[0] && _selectedImage != null) {
      return Image.file(File(_selectedImage!), height: 80,);
    }

    return null;
  }
}
