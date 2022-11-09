import 'package:flutter/material.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'package:velocity_x/velocity_x.dart';

class FriendsListManager extends StatelessWidget {
  const FriendsListManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.black500,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 60,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.black900,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 14.5,
                ),
                child: Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(right: 3.0),
                      child: Icon(
                        Icons.star_rounded,
                        color: Vx.gray400,
                        size: 26,
                      ),
                    ),
                    const Text(
                      "Friends",
                      style: TextStyle(
                        color: Vx.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: VerticalDivider(
                        color: Vx.gray400,
                        thickness: 0.5,
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Vx.green700),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Add Friend",
                        style: TextStyle(
                          color: Vx.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
