import 'package:flutter/material.dart';
import 'package:flutter_ninja_macropad/client/sse_client.dart';
import 'package:flutter_ninja_macropad/config/model/action_panel.dart';

class TabContent extends StatelessWidget {
  final List<ActionPanel> actions;

  const TabContent({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    int itemsPerRow =
        MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4;
    return Container(
      color: Colors.black87,
      child: GridView.builder(
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: itemsPerRow),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                  onTap: () {
                    SseClient.callAction(actions[index].actionExecutor);
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        boxShadow: [
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
                          child: Image.asset(
                            ('lib/assets/icons/${actions[index].actionIcon}'),
                            height: 80,
                          ),
                        ),
                        Center(
                            child: Text(
                          actions[index].actionName,
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
}
