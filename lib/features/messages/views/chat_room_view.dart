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
      appBar: AppBar(
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
              backgroundColor: AppTokens.avatarPalette[controller.conversation.id.hashCode % AppTokens.avatarPalette.length],
              child: Text(
                controller.conversation.avatarInitials,
                style: TextStyle(
                  color: AppTokens.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 10.w),
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
                  if (controller.conversation.isOnline)
                    Text(
                      'Online',
                      style: TextStyle(
                        color: AppTokens.white.withValues(alpha: 0.8),
                        fontSize: 10.sp,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppTokens.brandPrimary),
                );
              }

              final groups = controller.groupedMessages;
              
              if (groups.isEmpty) {
                return Center(
                  child: Text(
                    'No messages yet',
                    style: TextStyle(
                      color: AppTokens.textSecondary,
                      fontSize: 13.sp,
                    ),
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return Column(
                    children: [
                      // Date Header
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 16.h),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
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
                              fontSize: 10.sp,
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
                  padding: EdgeInsets.all(8.r),
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
                        style: TextStyle(fontSize: 12.sp, color: AppTokens.textSecondary),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
          
          // Input Area
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h).copyWith(
              bottom: 8.h + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: AppTokens.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: controller.pickAndSendImage,
                  icon: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppTokens.textSecondary,
                    size: 24.sp,
                  ),
                  splashRadius: 24.r,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppTokens.backgroundSecondary,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: TextField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(
                          color: AppTokens.textSecondary,
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        color: AppTokens.textPrimary,
                        fontSize: 14.sp,
                      ),
                      maxLines: 5,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => controller.sendMessage(),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: controller.sendMessage,
                  borderRadius: BorderRadius.circular(24.r),
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppTokens.brandPrimary,
                    child: Icon(
                      Icons.send_rounded,
                      color: AppTokens.white,
                      size: 18.sp,
                    ),
                  ),
                ),
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
        margin: EdgeInsets.only(bottom: 8.h),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppTokens.brandPrimary : AppTokens.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
            bottomLeft: Radius.circular(isMe ? 12.r : 2.r),
            bottomRight: Radius.circular(isMe ? 2.r : 12.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (model.attachmentUrl != null && model.attachmentUrl!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: model.attachmentUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 150.h,
                      width: double.infinity,
                      color: AppTokens.backgroundSecondary,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 150.h,
                      width: double.infinity,
                      color: AppTokens.backgroundSecondary,
                      child: Icon(Icons.broken_image, color: AppTokens.textSecondary),
                    ),
                  ),
                ),
              ),
            if (model.text.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Text(
                  model.text,
                  style: TextStyle(
                    color: isMe ? AppTokens.white : AppTokens.textPrimary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                timeStr,
                style: TextStyle(
                  color: (isMe ? AppTokens.white : AppTokens.textSecondary).withValues(alpha: 0.7),
                  fontSize: 9.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
