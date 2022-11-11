import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/domain/controllers/home_controller.dart';

class FriendsIconButton extends StatefulWidget {
  const FriendsIconButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconHoverColor,
    required this.backgroundColor,
    required this.backgroundHoverColor,
    this.onIconHoverEnter,
    this.onIconHoverExit,
    required this.iconSize,
    required this.iconRadius,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconHoverColor;
  final Color backgroundColor;
  final Color backgroundHoverColor;
  final double iconSize;
  final double iconRadius;
  final Function()? onIconHoverEnter;
  final Function()? onIconHoverExit;

  @override
  State<FriendsIconButton> createState() => _FriendsIconButtonState();
}

class _FriendsIconButtonState extends State<FriendsIconButton>
    with TickerProviderStateMixin {
  final HomeController _homeController = Get.find();

  static const Duration _duration = Duration(milliseconds: 125);

  late final AnimationController iconController;
  late final Animation<double> iconAnimation;

  late final AnimationController iconColorController;
  late final Animation<Color?> iconColorAnimation;

  late final AnimationController backgroundColorController;
  late final Animation<Color?> backgroundColorAnimation;

  bool isSelected = false;

  @override
  void initState() {
    iconController = AnimationController(vsync: this, duration: _duration)
      ..addListener(() {
        // Marks the widget tree as dirty
        setState(() {});
      });
    iconAnimation =
        Tween<double>(begin: widget.iconRadius, end: widget.iconRadius - 10.0)
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
      begin: widget.backgroundColor,
      end: widget.backgroundHoverColor,
    ).animate(iconColorController);

    _homeController.tabSelected.listen((AppTab state) {
      setState(() {
        isSelected = state == AppTab.friends;
      });

      if (isSelected) {
        iconController.forward();
        iconColorController.forward();
        backgroundColorController.forward();
      } else {
        iconController.reverse();
        iconColorController.reverse();
        backgroundColorController.reverse();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.iconSize,
      height: widget.iconSize,
      child: MouseRegion(
        onEnter: (PointerEvent d) {
          if (isSelected) {
            return;
          }
          iconController.forward();
          iconColorController.forward();
          backgroundColorController.forward();
        },
        onExit: (PointerEvent d) {
          if (isSelected) {
            return;
          }
          iconController.reverse();
          iconColorController.reverse();
          backgroundColorController.reverse();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(iconAnimation.value),
          child: Material(
            color: backgroundColorAnimation.value,
            child: IconButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                await prefs.remove("LastServerId");
                await prefs.remove("LastChannelId");
                _homeController.setSelectedTab(AppTab.friends);
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

// class _FriendsIconButtonState extends State<FriendsIconButton> {
//   static const Duration _duration = Duration(milliseconds: 125);

//   late final AnimationController iconController;
//   late final Animation<double> iconAnimation;

//   late final AnimationController iconColorController;
//   late final Animation<Color?> iconColorAnimation;

//   late final AnimationController backgroundColorController;
//   late final Animation<Color?> backgroundColorAnimation;

//   @override
//   void initState() {
//     // iconController = AnimationController(vsync: this, duration: _duration)
//     //   ..addListener(() {
//     //     // Marks the widget tree as dirty
//     //     setState(() {});
//     //   });
//     // iconAnimation =
//     //     Tween<double>(begin: widget.iconRadius, end: widget.iconRadius - 10.0)
//     //         .animate(iconController);

//     // iconColorController = AnimationController(vsync: this, duration: _duration)
//     //   ..addListener(() {
//     //     // Marks the widget tree as dirty
//     //     setState(() {});
//     //   });

//     // iconColorAnimation =
//     //     ColorTween(begin: widget.iconColor, end: widget.iconHoverColor)
//     //         .animate(iconColorController);

//     // backgroundColorController =
//     //     AnimationController(vsync: this, duration: _duration)
//     //       ..addListener(() {
//     //         // Marks the widget tree as dirty
//     //         setState(() {});
//     //       });

//     // backgroundColorAnimation = ColorTween(
//     //   begin: widget.backgroundColor,
//     //   end: widget.backgroundHoverColor,
//     // ).animate(iconColorController);

//     super.initState();
//   }

//   // @override
//   // void dispose() {
//   //   // iconController.dispose();
//   //   // iconColorController.dispose();
//   //   super.dispose();
//   // }

// }
