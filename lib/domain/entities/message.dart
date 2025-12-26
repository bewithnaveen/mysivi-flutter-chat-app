import 'package:equatable/equatable.dart';

enum MessageType { sender, receiver }

class Message extends Equatable {
  final String id;
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final String userId;
  final String chatId;

  const Message({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
    required this.userId,
    required this.chatId,
  });

  bool get isSender => type == MessageType.sender;
  bool get isReceiver => type == MessageType.receiver;

  Message copyWith({
    String? id,
    String? text,
    MessageType? type,
    DateTime? timestamp,
    String? userId,
    String? chatId,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      chatId: chatId ?? this.chatId,
    );
  }

  @override
  List<Object?> get props => [id, text, type, timestamp, userId, chatId];
}
