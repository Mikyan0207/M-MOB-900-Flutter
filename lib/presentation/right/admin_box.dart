import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../domain/entities/user_entity.dart';

class AdminBox extends StatelessWidget {
  const AdminBox({
    super.key,
    required this.adminUser,
  });

  final UserEntity adminUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: SizedBox(
            height: 40,
            width: 40,
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: adminUser.avatar.isNotEmptyAndNotNull
                      ? NetworkImage(adminUser.avatar)
                      : const NetworkImage(
                          "https://ddrg.farmasi.unej.ac.id/wp-content/uploads/sites/6/2017/10/unknown-person-icon-Image-from.png",
                        ),
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  adminUser.username.length > 13
                      ? '${adminUser.username.substring(0, 10)}...'
                      : adminUser.username,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Vx.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
