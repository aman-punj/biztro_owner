import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

abstract class ImageCompressionService {
  Future<File?> compressIfNeeded(File file, {int maxSizeInBytes = 1024 * 1024});
  Future<bool> isOverSize(File file, {int maxSizeInBytes = 1024 * 1024});
}

class ImageCompressionServiceImpl implements ImageCompressionService {
  @override
  Future<bool> isOverSize(File file, {int maxSizeInBytes = 1024 * 1024}) async {
    final size = await file.length();
    return size > maxSizeInBytes;
  }

  @override
  Future<File?> compressIfNeeded(File file, {int maxSizeInBytes = 1024 * 1024}) async {
    if (!await isOverSize(file, maxSizeInBytes: maxSizeInBytes)) {
      return file;
    }

    final filePath = file.absolute.path;
    final extension = p.extension(filePath).toLowerCase();
    
    // Skip if not an image or if it's a PDF (file_picker allows pdf for some types)
    if (extension != '.jpg' && extension != '.jpeg' && extension != '.png' && extension != '.heic') {
      return file;
    }

    final targetPath = p.join(
      (await getTemporaryDirectory()).path,
      '${p.basenameWithoutExtension(filePath)}_compressed${extension == '.heic' ? '.jpg' : extension}',
    );

    int quality = 90;
    File? compressedFile;

    while (quality > 10) {
      final result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        quality: quality,
        format: _getFormat(extension),
      );

      if (result == null) return null;

      compressedFile = File(result.path);
      if (await compressedFile.length() < maxSizeInBytes) {
        return compressedFile;
      }

      quality -= 10;
    }

    return compressedFile;
  }

  CompressFormat _getFormat(String extension) {
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return CompressFormat.jpeg;
      case '.png':
        return CompressFormat.png;
      case '.heic':
        return CompressFormat.heic;
      case '.webp':
        return CompressFormat.webp;
      default:
        return CompressFormat.jpeg;
    }
  }
}
