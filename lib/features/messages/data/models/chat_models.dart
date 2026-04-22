class ConversationModel {
  final String id;
  final String name;
  final String avatarInitials;
  final String? profileImage;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const ConversationModel({
    required this.id,
    required this.name,
    required this.avatarInitials,
    this.profileImage,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final String name = json['ContactName']?.toString() ?? 'Unknown';
    String initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    if (name.contains(' ')) {
      final parts = name.split(' ');
      if (parts.length > 1 && parts[1].isNotEmpty) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
    }

    return ConversationModel(
      id: json['ContactId']?.toString() ?? '',
      name: name,
      avatarInitials: initials,
      profileImage: json['ProfileImage']?.toString(),
      lastMessage: json['LastMessage']?.toString() ?? '',
      time: json['LastMessageTime']?.toString() ?? '',
      unreadCount: int.tryParse(json['UnreadCount']?.toString() ?? '0') ?? 0,
      isOnline: false,
    );
  }

  factory ConversationModel.fromNotificationData(Map<String, dynamic> data) {
    final String id = data['senderId']?.toString() ??
        data['chatId']?.toString() ??
        data['userId']?.toString() ??
        '';
    final String title = data['conversationName']?.toString().trim().isNotEmpty == true
        ? data['conversationName'].toString()
        : data['title']?.toString() ?? '';
    final String name = title.trim().isNotEmpty &&
            title != 'New message' &&
            int.tryParse(title) == null
        ? title
        : 'Customer $id';

    return ConversationModel(
      id: id,
      name: name,
      avatarInitials: _buildInitials(name),
      lastMessage: data['message']?.toString() ?? '',
      time: '',
      isOnline: false,
    );
  }

  static String _buildInitials(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return '?';

    final parts = trimmedName.split(RegExp(r'\s+'));
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return trimmedName[0].toUpperCase();
  }

  ConversationModel copyWith({
    String? id,
    String? name,
    String? avatarInitials,
    String? profileImage,
    String? lastMessage,
    String? time,
    int? unreadCount,
    bool? isOnline,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      profileImage: profileImage ?? this.profileImage,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

class ChatMessageModel {
  final String id;
  final String senderId;
  final String text;
  final String? attachmentUrl;
  final DateTime timestamp;
  final bool isFromMerchant;
  final String? dateGroup;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    this.attachmentUrl,
    required this.timestamp,
    required this.isFromMerchant,
    this.dateGroup,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    // API returns SentBy: "User" or "Merchant" (usually)
    final sentBy = json['SentBy']?.toString() ?? '';
    final bool isFromMerchant = sentBy != 'User';

    return ChatMessageModel(
      id: json['Id']?.toString() ?? json['id']?.toString() ?? '',
      senderId: json['SenderId']?.toString() ?? json['ReceiverId']?.toString() ?? '',
      text: json['MessageText']?.toString() ?? json['text']?.toString() ?? '',
      attachmentUrl: ChatMediaUrl.normalize(
        json['FilePath']?.toString() ?? json['attachmentUrl']?.toString(),
      ),
      timestamp: json['Timestamp'] != null 
          ? DateTime.parse(json['Timestamp'].toString()).toLocal()
          : (json['timestamp'] != null 
              ? DateTime.parse(json['timestamp'].toString()).toLocal()
              : DateTime.now()),
      isFromMerchant: isFromMerchant,
      dateGroup: json['DateGroup']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'attachmentUrl': attachmentUrl,
      'timestamp': timestamp.toIso8601String(),
      'isFromMerchant': isFromMerchant,
    };
  }
}

class ChatMediaUrl {
  ChatMediaUrl._();

  static const String host = 'https://mybizimages.in';

  static String normalize(String? path) {
    final normalizedPath = path?.trim() ?? '';
    if (normalizedPath.isEmpty) return '';

    final uri = Uri.tryParse(normalizedPath);
    if (uri != null && uri.hasScheme) {
      return normalizedPath;
    }

    final sanitizedPath = normalizedPath.replaceFirst(RegExp(r'^/+'), '');
    final encodedPath = Uri.encodeFull(sanitizedPath);
    return '$host/$encodedPath';
  }

  static bool isImagePath(String? value) {
    final path = value?.trim().toLowerCase() ?? '';
    if (path.isEmpty) return false;

    final uri = Uri.tryParse(path);
    final checkPath = uri?.path.toLowerCase() ?? path;
    return checkPath.endsWith('.png') ||
        checkPath.endsWith('.jpg') ||
        checkPath.endsWith('.jpeg') ||
        checkPath.endsWith('.webp') ||
        checkPath.endsWith('.gif');
  }
}

class ChatListUpdate {
  final String userId;
  final String lastMessage;
  final DateTime time;
  final int unreadCountDelta;

  ChatListUpdate({
    required this.userId,
    required this.lastMessage,
    required this.time,
    this.unreadCountDelta = 0,
  });
}
