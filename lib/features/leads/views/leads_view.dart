import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/leads/controllers/leads_controller.dart';
import 'package:bizrato_owner/features/leads/widgets/lead_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LeadsView extends GetView<LeadsController> {
  const LeadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Recent Leads',
      onFilter: () => _showFilterBottomSheet(context),
      clipContent: false,
      child: Stack(
        children: [
          _buildLeadList(),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: -24.h, // Adjusted to overlap the header border natively if AppPageShell structure permits, otherwise within content shell
      left: 16.w,
      right: 16.w,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: AppTokens.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppTokens.surfaceInverse.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchController,
          decoration: InputDecoration(
            hintText: 'Search by name, city or ID...',
            hintStyle: TextStyle(
              color: AppTokens.textSecondary,
              fontSize: 13.sp,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppTokens.textSecondary,
              size: 20.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
          style: TextStyle(
            color: AppTokens.textPrimary,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildLeadList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.hasError.value) {
        return Center(
          child: Text(
            controller.errorMessage.value,
            style: TextStyle(color: AppTokens.error, fontSize: 14.sp),
          ),
        );
      }

      final leads = controller.filteredLeads;

      if (leads.isEmpty) {
        return Center(
          child: Text(
            'No leads available.',
            style: TextStyle(color: AppTokens.textSecondary, fontSize: 14.sp),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.only(top: 40.h, bottom: 20.h, left: 16.w, right: 16.w), // Top padding for search bar overlap
        itemCount: leads.length,
        itemBuilder: (context, index) {
          final lead = leads[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: LeadCard(
              lead: lead,
              onCallPressed: () => controller.callLead(lead.mobileNo),
              onActionPressed: () => controller.handleAction(lead),
              onDetailsPressed: () => controller.handleDetails(lead),
            ),
          );
        },
      );
    });
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTokens.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 10.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppTokens.border,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 24.w), // Spacer
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.close, color: AppTokens.textPrimary, size: 24.sp),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                color: AppTokens.surface,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name...',
                  hintStyle: TextStyle(color: AppTokens.textSecondary, fontSize: 13.sp),
                  prefixIcon: Icon(Icons.search, color: AppTokens.textSecondary, size: 20.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Obx for filter switches
            Obx(() => _buildFilterOption(
              'Like by Date',
              controller.filterLikeByDate.value,
              controller.toggleFilterLikeByDate,
            )),
            Obx(() => _buildFilterOption(
              'Junk Lead',
              controller.filterJunkLead.value,
              controller.toggleFilterJunkLead,
            )),
            Obx(() => _buildFilterOption(
              'Interested',
              controller.filterInterested.value,
              controller.toggleFilterInterested,
            )),
            Obx(() => _buildFilterOption(
              'Not Interested',
              controller.filterNotInterested.value,
              controller.toggleFilterNotInterested,
            )),
            SizedBox(height: 24.h),
            PrimaryButton(
              label: 'Apply',
              onPressed: controller.applyFilter,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String text, bool value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: value ? AppTokens.brandPrimary : Colors.transparent,
                border: Border.all(
                  color: value ? AppTokens.brandPrimary : AppTokens.border,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: value
                  ? Icon(Icons.check, size: 14.sp, color: AppTokens.white)
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppTokens.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
