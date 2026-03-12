import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppScaffoldAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppScaffoldAppBar({
    required this.title,
    super.key,
    this.showBack = true,
    this.actions,
  });

  final String title;
  final bool showBack;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showBack && Get.canPop()
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: Get.back,
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
