import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    required this.path,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.borderRadius,
    this.showLoading = true,
    this.color,
    this.colorBlendMode,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final BorderRadius? borderRadius;
  final bool showLoading;
  final Color? color;
  final BlendMode? colorBlendMode;

  bool get _isNetworkImage {
    final Uri? uri = Uri.tryParse(path);
    if (uri == null) {
      return false;
    }

    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  bool get _isSvg => path.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (_isNetworkImage) {
      image = CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        placeholder: showLoading
            ? (context, url) => AppImageFallback.loading(
                  width: width,
                  height: height,
                )
            : (context, url) => const SizedBox.shrink(),
        errorWidget: (context, url, error) => AppImageFallback.error(
          width: width,
          height: height,
        ),
      );
    } else if (_isSvg) {
      final BlendMode? svgColorMode = color != null ? (colorBlendMode ?? BlendMode.srcIn) : null;
      image = SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        placeholderBuilder: showLoading
            ? (context) => AppImageFallback.loading(
                  width: width,
                  height: height,
                )
            : null,
        color: color,
        colorBlendMode: svgColorMode ?? BlendMode.srcIn ,
      );
    } else {
      final BlendMode? imageColorMode = color != null ? (colorBlendMode ?? BlendMode.srcIn) : null;
      image = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: imageColorMode,
        errorBuilder: (context, error, stackTrace) => AppImageFallback.error(
          width: width,
          height: height,
        ),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (!showLoading || wasSynchronouslyLoaded || frame != null) {
            return child;
          }

          return AppImageFallback.loading(
            width: width,
            height: height,
          );
        },
      );
    }

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(
      borderRadius: borderRadius!,
      child: image,
    );
  }
}

class AppImageFallback extends StatelessWidget {
  const AppImageFallback.loading({
    super.key,
    this.width,
    this.height,
  }) : isLoading = true;

  const AppImageFallback.error({
    super.key,
    this.width,
    this.height,
  }) : isLoading = false;

  final double? width;
  final double? height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              Icons.broken_image_outlined,
              color: AppColors.textSecondaryLight,
              size: 24,
            ),
    );
  }
}
