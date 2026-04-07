import 'dart:io';

import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FestivalDownloadService {
  FestivalDownloadService();

  static const MethodChannel _channel = MethodChannel(
    'bizrato_owner/festival_gallery',
  );
  final AppToastService _toastService = Get.find<AppToastService>();

  Future<File?> saveAndOpenImage({
    required List<int> bytes,
    required String fileName,
  }) async {
    try {
      if (Platform.isAndroid) {
        final savedUri = await _saveImageToAndroidGallery(
          bytes: bytes,
          fileName: fileName,
        );
        if (savedUri == null || savedUri.isEmpty) {
          _toastService.error('Unable to save the image to gallery.');
          return null;
        }

        _toastService.success('Image saved successfully.');

        final opened = await _openAndroidImageUri(savedUri);
        if (!opened) {
          _toastService.info(
            'Image saved to gallery, but could not open it automatically.',
          );
        }

        return null;
      }

      final file = await saveImage(bytes: bytes, fileName: fileName);

      if (file == null) {
        return null;
      }

      _toastService.success('Image saved successfully.');

      final opened = await _openInSystemViewer(file);
      if (!opened) {
        _toastService.info('Image saved locally, but could not open the gallery app.');
      }

      return file;
    } catch (_) {
      _toastService.error('Unable to download the festival image right now.');
      return null;
    }
  }

  Future<String?> _saveImageToAndroidGallery({
    required List<int> bytes,
    required String fileName,
  }) {
    return _channel.invokeMethod<String>(
      'saveImageToGallery',
      <String, dynamic>{
        'bytes': Uint8List.fromList(bytes),
        'fileName': _sanitizeFileName(fileName),
        'mimeType': _resolveMimeType(fileName),
      },
    );
  }

  Future<bool> _openAndroidImageUri(String uri) async {
    final opened = await _channel.invokeMethod<bool>(
      'openImageUri',
      <String, dynamic>{'uri': uri},
    );
    return opened ?? false;
  }

  Future<File?> saveImage({
    required List<int> bytes,
    required String fileName,
  }) async {
    final directory = await _resolveSaveDirectory();
    final sanitizedFileName = _sanitizeFileName(fileName);
    final file = File('${directory.path}\\$sanitizedFileName');

    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<Directory> _resolveSaveDirectory() async {
    if (Platform.isAndroid) {
      final picturesDirectory = Directory(
        '/storage/emulated/0/Pictures/Bizrato Merchant/Festivals',
      );
      try {
        if (!await picturesDirectory.exists()) {
          await picturesDirectory.create(recursive: true);
        }
        return picturesDirectory;
      } catch (_) {
        final externalDirectory = await getExternalStorageDirectory();
        if (externalDirectory != null) {
          final fallbackDirectory = Directory(
            '${externalDirectory.path}\\Festivals',
          );
          if (!await fallbackDirectory.exists()) {
            await fallbackDirectory.create(recursive: true);
          }
          return fallbackDirectory;
        }
      }
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final fallbackDirectory = Directory(
      '${documentsDirectory.path}${Platform.pathSeparator}Festivals',
    );
    if (!await fallbackDirectory.exists()) {
      await fallbackDirectory.create(recursive: true);
    }
    return fallbackDirectory;
  }

  Future<bool> _openInSystemViewer(File file) async {
    final fileUri = Uri.file(file.path);
    return launchUrl(
      fileUri,
      mode: LaunchMode.externalApplication,
    );
  }

  String _sanitizeFileName(String fileName) {
    final parts = fileName.split('.');
    if (parts.length < 2) {
      return fileName.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    }

    final extension = parts.removeLast().replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    final name = parts.join('.').replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    return '$name.$extension';
  }

  String _resolveMimeType(String fileName) {
    final normalized = fileName.toLowerCase();
    if (normalized.endsWith('.png')) {
      return 'image/png';
    }
    if (normalized.endsWith('.webp')) {
      return 'image/webp';
    }
    return 'image/jpeg';
  }
}
