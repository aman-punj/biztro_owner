import 'package:bizrato_owner/core/services/chat_service.dart';
import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/features/messages/controllers/chat_room_controller.dart';
import 'package:bizrato_owner/features/messages/data/models/chat_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
                            color: AppTokens.backgroundSecondary,
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
                        if (controller.connectionStatus.value ==
                            ConnectionStatus.connected) {
                          controller.sendMessage();
                        }
                      },
                    ),
                  ),
                ),

                SizedBox(width: 8.w),

                // Send Button
                Obx(() {
                  final isConnected = controller.connectionStatus.value ==
                      ConnectionStatus.connected;
                  final isEmpty =
                      controller.messageController.text.trim().isEmpty;

                  return InkWell(
                    onTap: (isConnected && !isEmpty)
                        ? controller.sendMessage
                        : null,
                    borderRadius: BorderRadius.circular(24.r),
                    child: CircleAvatar(
                      radius: 22.r,
                      backgroundColor: (isConnected && !isEmpty)
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
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppTokens.brandPrimary : AppTokens.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isMe ? 16.r : 4.r),
            bottomRight: Radius.circular(isMe ? 4.r : 16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.all(10.r),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Attachment
            if (model.attachmentUrl != null && model.attachmentUrl!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: model.attachmentUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 150.h,
                      width: double.infinity,
                      color: AppTokens.backgroundSecondary,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTokens.brandPrimary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 150.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTokens.backgroundSecondary,
                        borderRadius: BorderRadius.circular(8.r),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Text(
                  model.text,
                  style: TextStyle(
                    color: isMe ? AppTokens.white : AppTokens.textPrimary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),

            SizedBox(height: 4.h),

            // Timestamp
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                timeStr,
                style: TextStyle(
                  color: (isMe ? AppTokens.white : AppTokens.textSecondary)
                      .withValues(alpha: 0.6),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
