import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/features/feedback/data/models/feedback_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({
    super.key,
    required this.item,
    required this.onReplyPressed,
  });

  final FeedbackItemModel item;
  final VoidCallback onReplyPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppTokens.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppTokens.surfaceInverse.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: NetworkImage(item.userImage),
                backgroundColor: AppTokens.surface,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.userName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${item.location} • ${item.timeAgo}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.isVerified)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTokens.selectionBackground,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Verified',
                    style: TextStyle(
                      color: AppTokens.brandPrimary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: List.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Icon(
                  index < item.rating ? Icons.star : Icons.star_border,
                  size: 16.sp,
                  color: AppTokens.star,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            item.comment,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTokens.textPrimary,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onReplyPressed,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppTokens.secondaryButtonBackground,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 14.sp,
                      color: AppTokens.brandPrimary,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTokens.brandPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
