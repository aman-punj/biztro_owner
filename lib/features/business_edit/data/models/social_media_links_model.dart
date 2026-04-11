class SocialMediaLinksModel {
  const SocialMediaLinksModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SocialMediaLinksModel.fromJson(Map<String, dynamic> json) {
    final payload = _extractPayload(json);
    return SocialMediaLinksModel(
      success: _readBool(json, const <String>['success', 'Success'],
              fallback: true) &&
          _readBool(
            payload,
            const <String>['success', 'Success', 'isSuccess', 'IsSuccess'],
            fallback: true,
          ),
      message: _readString(payload, const <String>[
        'message',
        'Message',
        'MessageText',
      ], fallback: _readString(json, const <String>[
        'message',
        'Message',
        'MessageText',
      ])),
      data: SocialMediaLinksData.fromJson(payload),
    );
  }

  final bool success;
  final String message;
  final SocialMediaLinksData data;

  static Map<String, dynamic> _extractPayload(Map<String, dynamic> json) {
    for (final key in const <String>['result', 'Result', 'data', 'Data']) {
      final value = json[key];
      if (value is Map) {
        return value.cast<String, dynamic>();
      }
    }
    return json;
  }

  static String _readString(
    Map<String, dynamic> json,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return fallback;
  }

  static bool _readBool(
    Map<String, dynamic> json,
    List<String> keys, {
    bool fallback = false,
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value is bool) {
        return value;
      }
      if (value is num) {
        return value != 0;
      }
      if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true' || normalized == '1') {
          return true;
        }
        if (normalized == 'false' || normalized == '0') {
          return false;
        }
      }
    }
    return fallback;
  }
}

class SocialMediaLinksData {
  const SocialMediaLinksData({
    required this.facebookUrl,
    required this.twitterUrl,
    required this.instagramUrl,
    required this.linkedinUrl,
    required this.justdialUrl,
    required this.indiamartUrl,
    required this.websiteUrl,
    required this.youTubeUrl,
    required this.isPubliclyVisible,
  });

  factory SocialMediaLinksData.fromJson(Map<String, dynamic> json) {
    return SocialMediaLinksData(
      facebookUrl: SocialMediaLinksModel._readString(json, const <String>[
        'FacebookUrl',
        'facebookUrl',
      ]),
      twitterUrl: SocialMediaLinksModel._readString(json, const <String>[
        'TwitterUrl',
        'twitterUrl',
        'XUrl',
        'xUrl',
      ]),
      instagramUrl: SocialMediaLinksModel._readString(json, const <String>[
        'InstagramUrl',
        'instagramUrl',
      ]),
      linkedinUrl: SocialMediaLinksModel._readString(json, const <String>[
        'LinkedinUrl',
        'LinkedInUrl',
        'linkedinUrl',
        'linkedInUrl',
      ]),
      justdialUrl: SocialMediaLinksModel._readString(json, const <String>[
        'JustdialUrl',
        'JustDialUrl',
        'justdialUrl',
        'justDialUrl',
      ]),
      indiamartUrl: SocialMediaLinksModel._readString(json, const <String>[
        'IndiamartUrl',
        'IndiaMartUrl',
        'indiamartUrl',
        'indiaMartUrl',
      ]),
      websiteUrl: SocialMediaLinksModel._readString(json, const <String>[
        'WebsiteUrl',
        'websiteUrl',
      ]),
      youTubeUrl: SocialMediaLinksModel._readString(json, const <String>[
        'YouTubeUrl',
        'YoutubeUrl',
        'youTubeUrl',
        'youtubeUrl',
      ]),
      isPubliclyVisible: SocialMediaLinksModel._readBool(
        json,
        const <String>[
          'IsPubliclyVisible',
          'isPubliclyVisible',
        ],
      ),
    );
  }

  final String facebookUrl;
  final String twitterUrl;
  final String instagramUrl;
  final String linkedinUrl;
  final String justdialUrl;
  final String indiamartUrl;
  final String websiteUrl;
  final String youTubeUrl;
  final bool isPubliclyVisible;
}
