import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starlight/domain/controllers/channel_controller.dart';
import 'package:starlight/domain/entities/channel_entity.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class ChannelCard extends GetView<ChannelController> {
  const ChannelCard({
    Key? key,
    required this.isSelected,
    required this.channel,
  }) : super(key: key);

  final ChannelEntity channel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.setCurrentChannel(channel);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 6.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gray200 : Colors.transparent,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.numbers_rounded,
                    size: 22,
                    color: Vx.gray400,
                  ),
                ),
                Text(
                  getChannelName(),
                  style: TextStyle(
                    color: isSelected ? Vx.white : Vx.gray400,
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getChannelName() {
    return channel.name.isEmptyOrNull
        ? channel.id.trim().substring(
              0,
              channel.id.length > 20 ? 20 : channel.id.length,
            )
        : channel.name
            .trim()
            .substring(
              0,
              channel.name.length > 20 ? 20 : channel.name.length,
            )
            .toLowerCase();
  }
}
