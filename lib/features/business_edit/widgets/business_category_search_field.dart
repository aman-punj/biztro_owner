import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessCategorySearchField extends StatelessWidget {
  const BusinessCategorySearchField({
    required this.controller,
    required this.isCategoryRestored,
    required this.isSearching,
    required this.onClearRestoredCategory,
    required this.results,
    super.key,
  });

  final TextEditingController controller;
  final bool isCategoryRestored;
  final bool isSearching;
  final VoidCallback onClearRestoredCategory;
  final Widget results;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: controller,
          title: 'e.g. Sweets, Restaurant...',
          readOnly: isCategoryRestored,
          prefixIcon: Icon(
            Icons.search,
            size: 20.sp,
            color: AppTokens.textSecondary,
          ),
          suffixIcon: isCategoryRestored
              ? IconButton(
                  onPressed: onClearRestoredCategory,
                  icon: Icon(
                    Icons.close,
                    size: 18.sp,
                    color: AppTokens.textSecondary,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: results,
        ),
      ],
    );
  }
}
