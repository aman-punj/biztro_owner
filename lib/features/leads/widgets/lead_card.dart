import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/features/leads/data/models/lead_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LeadCard extends StatelessWidget {
  const LeadCard({
    super.key,
    required this.lead,
    required this.onActionPressed,
    required this.onDetailsPressed,
    required this.onCallPressed,
  });

  final LeadModel lead;
  final VoidCallback onActionPressed;
  final VoidCallback onDetailsPressed;
  final VoidCallback onCallPressed;

  @override
  Widget build(BuildContext context) {
    // Extract initial for avatar
    final initial = lead.userName.isNotEmpty ? lead.userName[0].toUpperCase() : '?';
    
    // Format date string from "2026-04-02T10:21:02.22" -> "02 APR 2026 | 10:21 AM"
    String dateLabel = '-';
    if (lead.leadDate != null && lead.leadDate!.isNotEmpty) {
      try {
        final date = DateTime.parse(lead.leadDate!);
        dateLabel = DateFormat('dd MMM yyyy | hh:mm a').format(date).toUpperCase();
      } catch (e) {
        dateLabel = lead.leadDate!;
      }
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppTokens.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTokens.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppTokens.info.withValues(alpha: 0.1),
                child: Text(
                  initial,
                  style: TextStyle(
                    color: AppTokens.info,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.userName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppTokens.brandPrimary, size: 12.sp),
                        SizedBox(width: 2.w),
                        Text(
                          lead.city ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppTokens.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(Icons.phone, color: AppTokens.brandPrimary, size: 12.sp),
                        SizedBox(width: 2.w),
                        Text(
                          lead.mobileNo ?? 'N/A',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppTokens.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // NEW Tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTokens.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'NEW',
                  style: TextStyle(
                    color: AppTokens.success,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DATE & TIME',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textSecondary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'LEAD IDENTITY',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textSecondary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    dateLabel,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '#UID-${lead.userId}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTokens.brandPrimary, // like Figma #UID blue
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.flash_on,
                  label: 'Action',
                  color: AppTokens.white,
                  backgroundColor: AppTokens.brandPrimary,
                  onTap: onActionPressed,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.info_outline,
                  label: 'Details',
                  color: AppTokens.brandPrimary,
                  backgroundColor: AppTokens.secondaryButtonBackground,
                  onTap: onDetailsPressed,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.phone_in_talk,
                  label: 'Call',
                  color: AppTokens.textPrimary,
                  backgroundColor: AppTokens.surface,
                  onTap: onCallPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
