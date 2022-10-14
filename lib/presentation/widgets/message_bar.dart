import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageBar extends StatelessWidget {
  MessageBar({super.key});

  final TextEditingController textarea = TextEditingController();

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
                color: Vx.gray500,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2.0,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Flexible(
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Vx.gray400,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Form(
                            key: UniqueKey(),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 150,
                              ),
                              child: TextFormField(
                                controller: textarea,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(
                                  color: Vx.gray100,
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
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: context.isMobile ? 6 : 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Flexible(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.sticky_note_2,
                                  color: Vx.gray300,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Flexible(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.emoji_emotions,
                                  color: Vx.gray300,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            const Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.0),
                                child: VerticalDivider(
                                  thickness: 0.5,
                                  color: Vx.gray400,
                                ),
                              ),
                            ),
                            Flexible(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Vx.indigo300,
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
