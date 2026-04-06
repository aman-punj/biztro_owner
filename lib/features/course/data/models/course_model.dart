class CourseModel {
  const CourseModel({
    required this.courseId,
    required this.courseName,
    required this.description,
    required this.totalVideos,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: (json['CourseId'] as num?)?.toInt() ?? 0,
      courseName: (json['CourseName'] as String? ?? '').trim(),
      description: (json['Description'] as String? ?? '').trim(),
      totalVideos: (json['TotalVideos'] as num?)?.toInt() ?? 0,
    );
  }

  final int courseId;
  final String courseName;
  final String description;
  final int totalVideos;
}

class CourseVideoModel {
  const CourseVideoModel({
    required this.videoId,
    required this.courseId,
    required this.videoTitle,
    required this.youtubeLink,
    required this.courseName,
  });

  factory CourseVideoModel.fromJson(Map<String, dynamic> json) {
    return CourseVideoModel(
      videoId: (json['VideoId'] as num?)?.toInt() ?? 0,
      courseId: (json['CourseId'] as num?)?.toInt() ?? 0,
      videoTitle: (json['VideoTitle'] as String? ?? '').trim(),
      youtubeLink: (json['YouTubeLink'] as String? ?? '').trim(),
      courseName: (json['CourseName'] as String? ?? '').trim(),
    );
  }

  final int videoId;
  final int courseId;
  final String videoTitle;
  final String youtubeLink;
  final String courseName;
}
