import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../themes/theme_colors.dart';

class CustomButton extends StatelessWidget
{
  const CustomButton({
    Key? key,
    required this.customText,
    required this.onClicked,
    this.customBackgroungColor = AppColors.primaryColor,
    this.customTextStyle = const TextStyle(color: Vx.gray100, fontSize: 10),
    this.customBorderRadius = 6,
  }) : super(key: key);

  final String customText;
  final Color customBackgroungColor;
  final TextStyle customTextStyle;
  final VoidCallback onClicked;
  final double customBorderRadius;


  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 18.0,
        ),
        backgroundColor: customBackgroungColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(customBorderRadius),
        ),
      ),
      onPressed: onClicked,
      child: Text(
        customText,
        style: customTextStyle,
      ),
    );
  }


}