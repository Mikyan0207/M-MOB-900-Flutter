
import 'package:flutter/material.dart';
import 'package:starlight/presentation/themes/theme_colors.dart';
import 'admin_list.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black700,
      child: AdminList(),
    );
  }
  
}