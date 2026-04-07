import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppOverlayLoader extends StatelessWidget {
  const AppOverlayLoader({
    super.key,
    required this.isVisible,
    required this.child,
    this.message,
  });

  final bool isVisible;
  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isVisible)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: ColoredBox(
                color: AppTokens.screenBackground.withValues(alpha:  0.18),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 94.w,
                      minHeight: 94.w,
                      maxWidth: 164.w,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTokens.cardBackground,
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(color: AppTokens.border),
                      boxShadow: [
                        BoxShadow(
                          color: AppTokens.textPrimary.withValues(alpha:  0.08),
                          blurRadius: 20.r,
                          offset: Offset(0.w, 8.h),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 30.w,
                          height: 30.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.6.w,
                            color: AppTokens.brandPrimary,
                          ),
                        ),
                        if (message != null && message!.trim().isNotEmpty) ...[
                          SizedBox(height: 12.h),
                          Text(
                            message!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTokens.textPrimary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
