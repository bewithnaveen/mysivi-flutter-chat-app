import 'dart:convert';
import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.text,
    required super.type,
    required super.timestamp,
    required super.userId,
    required super.chatId,
  });

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      text: message.text,
      type: message.type,
      timestamp: message.timestamp,
      userId: message.userId,
      chatId: message.chatId,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      text: json['text'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.sender,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: json['userId'] as String,
      chatId: json['chatId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'chatId': chatId,
    };
  }

  factory MessageModel.fromJsonString(String jsonString) {
    return MessageModel.fromJson(json.decode(jsonString));
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  Message toEntity() {
    return Message(
      id: id,
      text: text,
      type: type,
      timestamp: timestamp,
      userId: userId,
      chatId: chatId,
    );
  }
}
