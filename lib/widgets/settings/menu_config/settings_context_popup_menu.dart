import 'package:flutter/material.dart';


class MenuSettingsPanelPopupMenu extends StatelessWidget {
  final Function() showMenuConfigOverlay;
  final Function() showConnectionSettingsPopup;

  const MenuSettingsPanelPopupMenu(
      {super.key,
      required this.showMenuConfigOverlay,
      required this.showConnectionSettingsPopup
      });

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
                showMenuConfigOverlay();
              },
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Menu configuration',
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
                showConnectionSettingsPopup();
              },
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Connection settings',
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
