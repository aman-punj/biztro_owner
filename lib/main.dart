import 'package:bizrato_owner/core/dependencies/app_dependencies.dart';
import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/firebase_options.dart';
import 'package:bizrato_owner/routes/app_pages.dart' show AppPages;
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppDependencies.init();
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
          title: 'Bizrato Owner',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 280),
          initialRoute: AppRoutes.splash,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
