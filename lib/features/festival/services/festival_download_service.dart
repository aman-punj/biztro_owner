import 'dart:io';

import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class FestivalDownloadService {
  FestivalDownloadService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<File?> downloadAndPreview({
    required String imageUrl,
    required String fileName,
  }) async {
    try {
      final file = await downloadImage(
        imageUrl: imageUrl,
        fileName: fileName,
      );

      if (file == null) {
        return null;
      }

      await _showPreview(file: file);
      return file;
    } catch (_) {
      Get.snackbar(
        'Download failed',
        'Unable to download the festival image right now.',
      );
      return null;
    }
  }

  Future<File?> downloadImage({
    required String imageUrl,
    required String fileName,
  }) async {
    final directory = await getTemporaryDirectory();
    final sanitizedFileName =
        fileName.replaceAll(RegExp(r'[^A-Za-z0-9_\-]'), '_');
    final file = File('${directory.path}\\$sanitizedFileName');

    await _dio.download(imageUrl, file.path);
    return file;
  }

  Future<void> _showPreview({required File file}) {
    return Get.dialog<void>(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppTokens.cardBackground,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppTokens.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.file(
                  file,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Image downloaded successfully',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.textPrimary,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: Get.back,
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
