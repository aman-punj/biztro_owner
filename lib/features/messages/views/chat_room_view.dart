import 'package:bizrato_owner/core/services/chat_service.dart';
import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/features/messages/controllers/chat_room_controller.dart';
import 'package:bizrato_owner/features/messages/data/models/chat_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_assets.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.backgroundPrimary,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Connection Status Indicator
          Obx(() {
            final status = controller.connectionStatus.value;
            final isConnected = status == ConnectionStatus.connected;
            final isConnecting = status == ConnectionStatus.connecting;

            if (isConnected) return const SizedBox.shrink();

            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: isConnecting
                    ? AppTokens.warningBackground
                    : AppTokens.errorBackground,
                borderRadius: BorderRadius.circular(8.r),
              ),
              margin: EdgeInsets.all(8.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 12.r,
                    height: 12.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isConnecting
                          ? AppTokens.warningText
                          : AppTokens.errorText,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isConnecting ? 'Connecting...' : 'Connection Lost',
                    style: TextStyle(
                      color: isConnecting
                          ? AppTokens.warningText
                          : AppTokens.errorText,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTokens.backgroundSecondary,
                image: DecorationImage(
                  image:  AssetImage(AppAssets.splashBackground),
                  fit: BoxFit.cover,
                  opacity: 0.05,
                  colorFilter: ColorFilter.mode(
                    AppTokens.brandPrimary.withValues(alpha: 0.1),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTokens.brandPrimary,
                      strokeWidth: 3.r,
                    ),
                  );
                }

                final groups = controller.groupedMessages;

                if (groups.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 48.sp,
                          color: AppTokens.textSecondary.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            color: AppTokens.textSecondary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Start the conversation',
                          style: TextStyle(
                            color: AppTokens.textSecondary.withValues(alpha: 0.6),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return Column(
                      children: [
                        // Date Header
                        Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 16.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppTokens.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Text(
                              group.dateString,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppTokens.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        // Messages in this date
                        ...group.messages.map((msg) => ChatBubble(model: msg)),
                      ],
                    );
                  },
                );
              }),
            ),
          ),

          // Image Upload Progress
          Obx(() => controller.isUploadingImage.value
              ? Container(
                  padding: EdgeInsets.all(12.r),
                  color: AppTokens.backgroundSecondary,
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTokens.brandPrimary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Uploading image...',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTokens.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),

          // Input Area
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h).copyWith(
              bottom: 12.h + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: AppTokens.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Image Picker Button
                Obx(() {
                  final isConnected = controller.connectionStatus.value ==
                      ConnectionStatus.connected;
                  return IconButton(
                    onPressed: isConnected ? controller.pickAndSendImage : null,
                    icon: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: isConnected
                          ? AppTokens.textSecondary
                          : AppTokens.textSecondary.withValues(alpha: 0.5),
                      size: 24.sp,
                    ),
                    splashRadius: 24.r,
                    tooltip: isConnected ? 'Add image' : 'Connect first',
                  );
                }),

                // Message Input Field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTokens.backgroundSecondary,
                      borderRadius: BorderRadius.circular(28.r),
                      border: Border.all(
                        color: AppTokens.border,
                        width: 0.5,
                      ),
                    ),
                    child: TextField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: AppTokens.textSecondary.withValues(alpha: 0.6),
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                      style: TextStyle(
                        color: AppTokens.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) {
                        if (controller.canSendMessage) {
                          controller.sendMessage();
                        }
                      },
                    ),
                  ),
                ),

                SizedBox(width: 8.w),

                // Send Button
                Obx(() {
                  final canSend = controller.canSendMessage;

                  return InkWell(
                    onTap: canSend ? controller.sendMessage : null,
                    borderRadius: BorderRadius.circular(24.r),
                    child: CircleAvatar(
                      radius: 22.r,
                      backgroundColor: canSend
                          ? AppTokens.brandPrimary
                          : AppTokens.brandPrimary.withValues(alpha: 0.5),
                      child: Icon(
                        Icons.send_rounded,
                        color: AppTokens.white,
                        size: 19.sp,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppTokens.brandPrimary,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        onPressed: Get.back,
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18.sp,
          color: AppTokens.white,
        ),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: AppTokens.avatarPalette[
                controller.conversation.id.hashCode %
                    AppTokens.avatarPalette.length],
            child: Text(
              controller.conversation.avatarInitials,
              style: TextStyle(
                color: AppTokens.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.conversation.name,
                  style: TextStyle(
                    color: AppTokens.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Obx(() {
                  final status = controller.connectionStatus.value;
                  final statusText = status == ConnectionStatus.connected
                      ? (controller.conversation.isOnline
                          ? 'Online'
                          : 'Offline')
                      : 'Connecting...';
                  final statusColor = status == ConnectionStatus.connected
                      ? AppTokens.white.withValues(alpha: 0.9)
                      : AppTokens.white.withValues(alpha: 0.6);

                  return Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({required this.model, super.key});

  final ChatMessageModel model;

  @override
  Widget build(BuildContext context) {
    final isMe = model.isFromMerchant;
    final timeStr = DateFormat.jm().format(model.timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 12.h,
          left: isMe ? 40.w : 0,
          right: isMe ? 0 : 40.w,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? AppTokens.brandPrimary : AppTokens.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                  bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
                  bottomRight: Radius.circular(isMe ? 4.r : 18.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(2.r),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(isMe ? 16.r : 4.r),
                  bottomRight: Radius.circular(isMe ? 4.r : 16.r),
                ),
                child: Container(
                  color: isMe ? AppTokens.brandPrimary : AppTokens.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image Attachment
                      if (model.attachmentUrl != null &&
                          model.attachmentUrl!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: CachedNetworkImage(
                              imageUrl: model.attachmentUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 180.h,
                                width: double.infinity,
                                color: AppTokens.backgroundSecondary,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTokens.brandPrimary,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 180.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppTokens.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: AppTokens.textSecondary,
                                  size: 32.sp,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Message Text
                      if (model.text.isNotEmpty)
                        Text(
                          model.text,
                          style: TextStyle(
                            color:
                                isMe ? AppTokens.white : AppTokens.textPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.45,
                          ),
                        ),

                      SizedBox(height: 4.h),

                      // Timestamp and Status
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timeStr,
                            style: TextStyle(
                              color: (isMe
                                      ? AppTokens.white
                                      : AppTokens.textSecondary)
                                  .withValues(alpha: 0.7),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (isMe) ...[
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.done_all_rounded,
                              size: 14.sp,
                              color: AppTokens.white.withValues(alpha: 0.8),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
