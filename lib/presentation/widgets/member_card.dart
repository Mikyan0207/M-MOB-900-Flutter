import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:starlight/presentation/widgets/profile_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../domain/entities/user_entity.dart';

class MemberCard extends StatefulWidget {
  const MemberCard({
    super.key,
    required this.member,
  });

  final UserEntity member;

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  bool _isHovered = false;

  Widget buildStatus() => ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: SizedBox(
          width: 17,
          height: 17,
          child: Container(
            color: AppColors.black800,
            child: Padding(
              padding: const EdgeInsets.all(2.5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Container(
                  color: widget.member.status == "online"
                      ? Vx.green600
                      : Vx.gray500,
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (PointerEnterEvent? event) => setState(() {
        _isHovered = true;
      }),
      onExit: (PointerExitEvent? event) => setState(() {
        _isHovered = false;
      }),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: _isHovered ? AppColors.black500 : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 10.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Stack(
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: Ink.image(
                            colorFilter: ColorFilter.mode(
                                widget.member.status == "online"
                                    ? Colors.transparent
                                    : Vx.gray700.withOpacity(0.45),
                                BlendMode.darken),
                            image: widget.member.avatar.isNotEmptyAndNotNull
                                ? NetworkImage(widget.member.avatar)
                                : const NetworkImage(
                                    "https://ddrg.farmasi.unej.ac.id/wp-content/uploads/sites/6/2017/10/unknown-person-icon-Image-from.png",
                                  ),
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: buildStatus(),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.member.username.length > 16
                            ? '${widget.member.username.substring(0, 13)}...'
                            : widget.member.username,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: widget.member.status == "online"
                              ? Vx.white
                              : Vx.gray500,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        widget.member.discriminator,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: widget.member.status == "online"
                              ? Vx.white
                              : Vx.gray500,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
