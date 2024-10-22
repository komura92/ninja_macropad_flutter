import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/widgets/settings/dialog_button.dart';

class ConnectionSettingsDialog extends StatefulWidget {
  final TextEditingController serverUrlController;
  final TextEditingController selectedDeviceController;
  VoidCallback onSave;
  VoidCallback onCancel;
  String? deviceValue;
  final List<String> availableDevices;

  ConnectionSettingsDialog({
    super.key,
    required this.serverUrlController,
    required this.selectedDeviceController,
    required this.onSave,
    required this.onCancel,
    required this.availableDevices
  }) : deviceValue = selectedDeviceController.text.isEmpty
            ? null
            : selectedDeviceController.text;

  @override
  State<ConnectionSettingsDialog> createState() => _ConnectionSettingsDialogState();
}

class _ConnectionSettingsDialogState extends State<ConnectionSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Settings',
        style: TextStyle(
          color: Colors.grey.shade300,
        ),
      ),
      backgroundColor: Colors.blue.shade800,
      content: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: Colors.grey.shade800,
                hint: Text(
                  'Device to control',
                  style: TextStyle(color: Colors.grey.shade300,
                    fontSize: 16,),
                ),
                value: widget.deviceValue,
                icon: Icon(Icons.arrow_downward, color: Colors.grey.shade300),
                elevation: 16,
                style: TextStyle(color: Colors.grey.shade300),
                onChanged: (String? value) {
                  setState(() {
                    widget.deviceValue = value;
                    widget.selectedDeviceController.text = value ?? '';
                  });
                },
                items: widget.availableDevices.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: widget.serverUrlController,
                  style: TextStyle(color: Colors.grey.shade300),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 16,
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.normal),
                    hintText: "Server subscribe URL",
                    suffixIcon: IconButton(
                      onPressed: widget.serverUrlController.clear,
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                )),
            const SizedBox(width: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DialogButton(text: "Save", onPressed: widget.onSave),
                const SizedBox(width: 8),
                DialogButton(text: "Cancel", onPressed: widget.onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
