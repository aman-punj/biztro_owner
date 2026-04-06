import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppPageShell extends StatelessWidget {
  const AppPageShell({
    super.key,
    required this.title,
    required this.child,
    this.onBack,
    this.onHelp,
    this.onYoutube,
    this.showBack = true,
    this.headerHeight = 140,  
    this.overlapAmount = 40, 
    this.headerImage,
    this.headerColor = AppTokens.brandPrimary,
  });

  final String title;
  final Widget child;
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onHelp;
  final VoidCallback? onYoutube;
  final double headerHeight;
  final double overlapAmount;
  final Widget? headerImage;
  final Color headerColor;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final topPadding = media.padding.top;
    final safeOverlap = overlapAmount.h;
    final headerTotalHeight = headerHeight.h + topPadding;
    final contentTop = headerTotalHeight - safeOverlap;

    return Scaffold(
      backgroundColor: AppTokens.screenBackground,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Blue Header Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerTotalHeight,
            child: CustomPaint(
              painter: _AppHeaderPainter(color: headerColor),
              child: Container(),
            ),
          ),

          // Header Content (Back, Title, Help/YT)
          Positioned(
            top: topPadding,
            left: 0,
            right: 0,
            child: Container(
              height: 100.h, // Fixed height for the navigation area
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Back Button (Left)
                  if (showBack)
                    Positioned(
                      left: 0,
                      child: GestureDetector(
                        onTap: onBack ?? Get.back,
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),

                  // Title (Center)
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // Actions (Right)
                  Positioned(
                    right: 0,
                    child: _HeaderActions(
                      onHelp: onHelp,
                      onYoutube: onYoutube,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Card (The White Body)
          Positioned(
            top: contentTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal:
                      26), // To ensure content doesn't get hidden under header
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.r),
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions({this.onHelp, this.onYoutube});

  final VoidCallback? onHelp;
  final VoidCallback? onYoutube;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onHelp != null) ...[
          GestureDetector(
            onTap: onHelp,
            child: Text(
              'Help',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: 6.w),
        ],
        if (onYoutube != null)
          GestureDetector(
            onTap: onYoutube,
            child: Icon(
              Icons.play_circle_fill, // Filled icon to match brand logo look
              color: Colors.redAccent,
              size: 24.sp,
            ),
          ),
      ],
    );
  }
}

class _AppHeaderPainter extends CustomPainter {
  _AppHeaderPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Drawing the blue header with bottom rounded corners
    final path = Path()
      ..lineTo(0, size.height - 30.r)
      ..quadraticBezierTo(0, size.height, 30.r, size.height)
      ..lineTo(size.width - 30.r, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - 30.r)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AppHeaderPainter oldDelegate) =>
      oldDelegate.color != color;
}
