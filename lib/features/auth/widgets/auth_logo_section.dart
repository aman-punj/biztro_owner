import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthLogoSection extends StatelessWidget {
  const AuthLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 72.h,
          width: 140.w,
          alignment: Alignment.center,
          child: Text(
            'Your Logo',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
