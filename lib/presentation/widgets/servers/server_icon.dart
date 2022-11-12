import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/home_controller.dart';
import 'package:starlight/domain/controllers/server_controller.dart';
import 'package:starlight/domain/entities/server_entity.dart';

class ServerIcon extends StatefulWidget {
  const ServerIcon({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.iconRadius,
    required this.serverId,
    this.onIconClicked,
  });

  final String icon;
  final double iconRadius;
  final double iconSize;
  final String serverId;
  final Future<void> Function()? onIconClicked;

  @override
  State<ServerIcon> createState() => _ServerIconState();
}

class _ServerIconState extends State<ServerIcon>
    with SingleTickerProviderStateMixin {
  double _radius = 25;
  double _size = 50;

  final HomeController _homeController = Get.find();
  final ServerController _serverController = Get.find();

  static const Duration _duration = Duration(milliseconds: 125);

  late final AnimationController iconController;
  late final Animation<double> iconAnimation;

  bool isSelected = false;

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

    _homeController.tabSelected.listen((AppTab e) {
      setState(() {
        isSelected =
            _serverController.currentServer.value.id == widget.serverId &&
                e == AppTab.servers;
      });

      if (isSelected) {
        iconController.forward();
      } else {
        iconController.reverse();
      }
    });
    _serverController.currentServer.listen((ServerEntity e) {
      setState(() {
        isSelected = e.id == widget.serverId &&
            _homeController.tabSelected.value == AppTab.servers;
      });

      if (isSelected) {
        iconController.forward();
      } else {
        iconController.reverse();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEvent d) {
        if (isSelected) {
          return;
        }
        iconController.forward();
      },
      onExit: (PointerEvent d) {
        if (isSelected) {
          return;
        }
        iconController.reverse();
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
