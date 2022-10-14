import 'package:flutter/material.dart';
import 'package:starlight/presentation/widgets/server_icon.dart';
import 'package:velocity_x/velocity_x.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Vx.gray800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Vx.gray800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    children: const <Widget>[
                      ServerIcon(
                        iconRadius: 25,
                        iconSize: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ServerIcon(
                        iconRadius: 25,
                        iconSize: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ServerIcon(
                        iconRadius: 25,
                        iconSize: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ServerIcon(
                        iconRadius: 25,
                        iconSize: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: Vx.gray700,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
