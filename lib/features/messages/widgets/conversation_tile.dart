import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/features/messages/controllers/messages_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({required this.model, super.key});

  final ConversationModel model;

  Color get _avatarColor {
    return AppTokens
        .avatarPalette[model.id.hashCode % AppTokens.avatarPalette.length];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: _avatarColor,
                  child: Text(
                    model.avatarInitials,
                    style: TextStyle(
                      color: AppTokens.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (model.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10.r,
                      height: 10.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTokens.online,
                        border: Border.all(color: AppTokens.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.name,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: model.unreadCount > 0
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: AppTokens.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        model.time,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.lastMessage,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: model.unreadCount > 0
                                ? AppTokens.textPrimary
                                : AppTokens.textSecondary,
                            fontWeight: model.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (model.unreadCount > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTokens.brandPrimary,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            '${model.unreadCount}',
                            style: TextStyle(
                              color: AppTokens.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
