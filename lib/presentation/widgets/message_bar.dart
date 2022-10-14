import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageBar extends StatelessWidget {
  const MessageBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 25,
              maxHeight: 150,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Vx.gray600,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      const Flexible(
                        child: Icon(
                          Icons.add_circle,
                          color: Vx.gray400,
                        ),
                      ),
                      Expanded(
                        flex: 86,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Form(
                            key: UniqueKey(),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(
                                color: Vx.gray300,
                              ),
                              cursorColor: Vx.gray400,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Vx.gray500,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .fontSize,
                                ),
                                hintText: 'Message #{CHANNEL}',
                                contentPadding: const EdgeInsets.all(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const Flexible(
                              flex: 5,
                              child: Icon(
                                Icons.sticky_note_2,
                                color: Vx.gray300,
                              ),
                            ),
                            const Flexible(
                              flex: 5,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: Icon(
                                  Icons.emoji_emotions,
                                  color: Vx.gray300,
                                ),
                              ),
                            ),
                            const Flexible(
                              flex: 5,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: VerticalDivider(
                                  thickness: 0.5,
                                  color: Vx.white,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Vx.indigo400,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
