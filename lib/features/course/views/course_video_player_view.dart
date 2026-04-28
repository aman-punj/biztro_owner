import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_page_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseVideoPlayerView extends StatefulWidget {
  const CourseVideoPlayerView({super.key});

  @override
  State<CourseVideoPlayerView> createState() => _CourseVideoPlayerViewState();
}

class _CourseVideoPlayerViewState extends State<CourseVideoPlayerView> {
  YoutubePlayerController? _youtubeController;
  late final String _title;
  late final String _videoId;

  bool get _isVideoReady => _videoId.isNotEmpty && _youtubeController != null;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    final data = arguments is Map ? arguments : <String, dynamic>{};

    _title = (data['title']?.toString() ?? '').trim();
    _videoId = (data['videoId']?.toString() ?? '').trim();

    if (_videoId.isNotEmpty) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: _videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVideoReady) {
      return AppPageShell(
        title: 'Video Lecture',
        child: Center(
          child: Text(
            'Unable to load this video.',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTokens.textSecondary,
            ),
          ),
        ),
      );
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubeController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppTokens.brandPrimary,
        progressColors: ProgressBarColors(
          playedColor: AppTokens.brandPrimary,
          handleColor: AppTokens.brandPrimary,
          bufferedColor: AppTokens.brandPrimary.withValues(alpha: 0.35),
          backgroundColor: AppTokens.border,
        ),
      ),
      builder: (context, player) {
        return AppPageShell(
          title: 'Video Lecture',
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_title.isNotEmpty) ...[
                  Text(
                    _title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textPrimary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: player,
                ),
                SizedBox(height: 12.h),
                Text(
                  'If playback is restricted by the video owner, YouTube may block embedded playback.',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
