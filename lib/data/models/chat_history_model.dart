import 'dart:convert';
import '../../domain/entities/chat_history.dart';
import 'user_model.dart';

class ChatHistoryModel extends ChatHistory {
  const ChatHistoryModel({
    required super.id,
    required super.user,
    required super.lastMessage,
    required super.lastMessageTime,
    super.unreadCount,
  });

  factory ChatHistoryModel.fromEntity(ChatHistory chatHistory) {
    return ChatHistoryModel(
      id: chatHistory.id,
      user: chatHistory.user,
      lastMessage: chatHistory.lastMessage,
      lastMessageTime: chatHistory.lastMessageTime,
      unreadCount: chatHistory.unreadCount,
    );
  }

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(
      id: json['id'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>).toEntity(),
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': UserModel.fromEntity(user).toJson(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }

  factory ChatHistoryModel.fromJsonString(String jsonString) {
    return ChatHistoryModel.fromJson(json.decode(jsonString));
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  ChatHistory toEntity() {
    return ChatHistory(
      id: id,
      user: user,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      unreadCount: unreadCount,
    );
  }
}
