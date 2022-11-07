import 'package:flutter/material.dart';

class StarlightIconButton extends StatefulWidget {
  const StarlightIconButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconHoverColor,
    required this.backgroundColor,
    required this.backgroundHoverColor,
    this.onIconHoverEnter,
    this.onIconHoverExit,
    this.onIconClicked,
    this.iconSize,
    this.iconRadius,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconHoverColor;
  final Color backgroundColor;
  final Color backgroundHoverColor;
  final double? iconSize;
  final double? iconRadius;
  final Function()? onIconHoverEnter;
  final Function()? onIconHoverExit;
  final Future<void> Function()? onIconClicked;

  @override
  State<StarlightIconButton> createState() => _StarlightIconButtonState();
}

class _StarlightIconButtonState extends State<StarlightIconButton>
    with TickerProviderStateMixin {
  double _radius = 25;
  double _size = 50;

  static const Duration _duration = Duration(milliseconds: 125);

  late final AnimationController iconController;
  late final Animation<double> iconAnimation;

  late final AnimationController iconColorController;
  late final Animation<Color?> iconColorAnimation;

  late final AnimationController backgroundColorController;
  late final Animation<Color?> backgroundColorAnimation;

  @override
  void initState() {
    _radius = widget.iconRadius ?? 25;
    _size = widget.iconSize ?? 50;

    iconController = AnimationController(vsync: this, duration: _duration)
      ..addListener(() {
        // Marks the widget tree as dirty
        setState(() {});
      });
    iconAnimation = Tween<double>(begin: _radius, end: _radius - 10.0)
        .animate(iconController);

    iconColorController = AnimationController(vsync: this, duration: _duration)
      ..addListener(() {
        // Marks the widget tree as dirty
        setState(() {});
      });

    iconColorAnimation =
        ColorTween(begin: widget.iconColor, end: widget.iconHoverColor)
            .animate(iconColorController);

    backgroundColorController =
        AnimationController(vsync: this, duration: _duration)
          ..addListener(() {
            // Marks the widget tree as dirty
            setState(() {});
          });

    backgroundColorAnimation = ColorTween(
            begin: widget.backgroundColor, end: widget.backgroundHoverColor)
        .animate(iconColorController);

    super.initState();
  }

  @override
  void dispose() {
    iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: MouseRegion(
        onEnter: (PointerEvent d) => <void>{
          iconController.forward(),
          iconColorController.forward(),
        },
        onExit: (PointerEvent d) => <void>{
          iconController.reverse(),
          iconColorController.reverse(),
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(iconAnimation.value),
          child: Material(
            color: backgroundColorAnimation.value,
            child: IconButton(
              onPressed: () async {
                await widget.onIconClicked?.call();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                widget.icon,
                color: iconColorAnimation.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
