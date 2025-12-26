import 'package:equatable/equatable.dart';
import 'user.dart';

class ChatHistory extends Equatable {
  final String id;
  final User user;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ChatHistory({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
    }
  }

  ChatHistory copyWith({
    String? id,
    User? user,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) {
    return ChatHistory(
      id: id ?? this.id,
      user: user ?? this.user,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [id, user, lastMessage, lastMessageTime, unreadCount];
}
