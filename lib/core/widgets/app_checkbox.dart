import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    required this.isSelected,
    super.key,
    this.size,
  });

  final bool isSelected;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final double widgetSize = size ?? 18.w;
    
    return AppImage(
      path: isSelected ? AppAssets.checkboxFilled : AppAssets.checkboxEmpty,
      width: widgetSize,
      height: widgetSize,
    );
  }
}
