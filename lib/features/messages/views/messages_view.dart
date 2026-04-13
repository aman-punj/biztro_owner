import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/features/messages/controllers/messages_controller.dart';
import 'package:bizrato_owner/features/messages/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MessagesView extends GetView<MessagesController> {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.white,
      appBar: AppBar(
        backgroundColor: AppTokens.brandPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sp,
            color: AppTokens.white,
          ),
        ),
        title: Column(
          children: [
            Text(
              'Messages',
              style: TextStyle(
                color: AppTokens.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Obx(
              () => Text(
                '${controller.filteredConversations.length} Conversations',
                style: TextStyle(
                  color: AppTokens.white.withValues(alpha: 0.8),
                  fontSize: 9.sp,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              radius: 14.r,
              backgroundColor: AppTokens.white.withValues(alpha: 0.2),
              child: Icon(
                Icons.person_outline,
                size: 16.sp,
                color: AppTokens.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppTokens.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: Icon(
                  Icons.search,
                  size: 18.sp,
                  color: AppTokens.textSecondary,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 10.h,
                ),
              ),
            ),
          ),

          // Conversation list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppTokens.brandPrimary),
                );
              }

              if (controller.hasError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_outlined,
                        size: 40.sp,
                        color: AppTokens.textSecondary,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Failed to load messages',
                        style: TextStyle(
                          color: AppTokens.textSecondary,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: controller.refreshConversations,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final conversations = controller.filteredConversations;

              if (conversations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 40.sp,
                        color: AppTokens.textSecondary,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'No conversations found',
                        style: TextStyle(
                          color: AppTokens.textSecondary,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshConversations,
                color: AppTokens.brandPrimary,
                child: ListView.separated(
                  itemCount: conversations.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    indent: 66.w,
                    color: AppTokens.border,
                  ),
                  itemBuilder: (context, index) {
                    return ConversationTile(model: conversations[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
