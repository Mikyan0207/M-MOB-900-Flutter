import 'package:flutter/material.dart';
import 'package:starlight/presentation/widgets/profile_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../domain/entities/user_entity.dart';

class AdminBox extends StatelessWidget {
  const AdminBox({
    super.key,
    required this.adminUser,
  });

  final UserEntity adminUser;

  Widget buildStatus() => buildCircle(
    color: adminUser.status == "online" ? Colors.green : Colors.white10,
    all: 2,
    child: buildCircle(
      color: adminUser.status == "online" ? Colors.green : Colors.white10,
      all: 2,
      child: const Icon(
        Icons.add_circle,
        color: Colors.transparent,
        size: 3,
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child:
            SizedBox(
              height: 40,
              width: 40,
              child:
                Stack(
                  children: <Widget>[
                    ClipOval(
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
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: buildStatus(),
                    ),
                  ],
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
