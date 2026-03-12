import 'package:biztro_owner/core/theme/theme.dart';
import 'package:biztro_owner/routes/app_pages.dart';
import 'package:biztro_owner/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  runApp(const BiztroOwnerApp());
}

class BiztroOwnerApp extends StatelessWidget {
  const BiztroOwnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Biztro Owner',
          initialRoute: AppRoutes.login,
          getPages: AppPages.pages,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
