import 'package:flutter/material.dart';

class ServerIcon extends StatefulWidget {
  const ServerIcon({
    super.key,
    required this.iconSize,
    required this.iconRadius,
  });

  final double iconRadius;
  final double iconSize;

  @override
  State<ServerIcon> createState() => _ServerIconState();
}

class _ServerIconState extends State<ServerIcon> {
  double _radius = 25;
  double _size = 50;
  final String placeholder =
      "https://static.vecteezy.com/system/resources/previews/007/479/717/original/icon-contacts-suitable-for-mobile-apps-symbol-long-shadow-style-simple-design-editable-design-template-simple-symbol-illustration-vector.jpg";

  @override
  void initState() {
    _radius = widget.iconRadius;
    _size = widget.iconSize;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEvent d) {
        setState(() {
          _radius = 15;
        });
      },
      onExit: (PointerEvent d) {
        setState(() {
          _radius = 25;
        });
      },
      child: SizedBox(
        width: _size,
        height: _size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius),
          child: Material(
            color: Colors.transparent,
            child: Ink.image(
              image: NetworkImage(
                placeholder,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
