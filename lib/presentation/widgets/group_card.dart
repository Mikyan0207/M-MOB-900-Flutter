import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/home_controller.dart';
import 'package:starlight/domain/controllers/private_message_controller.dart';
import 'package:starlight/domain/entities/group_entity.dart';
import 'package:velocity_x/velocity_x.dart';

class GroupCard extends StatelessWidget {
  GroupCard({
    super.key,
    required this.group,
    this.isSelected = false,
  });

  final GroupEntity group;
  final bool isSelected;

  final PrivateMessageController _pmController = Get.find();
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _pmController.setCurrentGroup(group);
        _homeController.setSelectedTab(AppTab.privateMessage);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Vx.gray400 : Colors.transparent,
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 2.0,
          ),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipOval(
                    child: Image.network(
                      group.icon,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  group.name,
                  style: TextStyle(
                    color: isSelected ? Vx.white : Vx.gray300,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
