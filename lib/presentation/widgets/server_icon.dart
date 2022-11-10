import 'package:flutter/material.dart';

class ServerIcon extends StatefulWidget {
  const ServerIcon({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.iconRadius,
    this.onIconClicked,
  });

  final String icon;
  final double iconRadius;
  final double iconSize;
  final Future<void> Function()? onIconClicked;

  @override
  State<ServerIcon> createState() => _ServerIconState();
}

class _ServerIconState extends State<ServerIcon>
    with SingleTickerProviderStateMixin {
  double _radius = 25;
  double _size = 50;

  static const Duration _duration = Duration(milliseconds: 125);

  late final AnimationController iconController;
  late final Animation<double> iconAnimation;

  @override
  void initState() {
    _radius = widget.iconRadius;
    _size = widget.iconSize;

    iconController = AnimationController(vsync: this, duration: _duration)
      ..addListener(() {
        // Marks the widget tree as dirty
        setState(() {});
      });
    iconAnimation = Tween<double>(begin: _radius, end: _radius - 10.0)
        .animate(iconController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEvent d) => <void>{
        iconController.forward(),
      },
      onExit: (PointerEvent d) => <void>{
        iconController.reverse(),
      },
      child: SizedBox(
        width: _size,
        height: _size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(iconAnimation.value),
          child: Material(
            color: Colors.transparent,
            child: Ink.image(
              image: NetworkImage(
                widget.icon,
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await widget.onIconClicked?.call();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
