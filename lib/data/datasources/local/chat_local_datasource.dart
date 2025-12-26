import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../models/chat_history_model.dart';
import '../../models/message_model.dart';
import '../../../domain/entities/message.dart';
import '../../models/user_model.dart';

abstract class ChatLocalDataSource {
  Future<List<ChatHistoryModel>> getChatHistory();
  Future<List<MessageModel>> getChatMessages(String chatId);
  Future<MessageModel> sendMessage({
    required String chatId,
    required String userId,
    required String text,
    required MessageType type,
  });
  Future<void> updateChatHistory({
    required String chatId,
    required String lastMessage,
    required DateTime lastMessageTime,
  });
  Future<void> createChatHistory({
    required String chatId,
    required UserModel user,
    required String lastMessage,
    required DateTime lastMessageTime,
  });
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String _chatHistoryKey = 'chat_history';
  static const String _messagesKeyPrefix = 'messages_';
  final SharedPreferences sharedPreferences;
  final Uuid _uuid = const Uuid();

  ChatLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<ChatHistoryModel>> getChatHistory() async {
    try {
      final chatHistoryJson = sharedPreferences.getString(_chatHistoryKey);
      if (chatHistoryJson == null || chatHistoryJson.isEmpty) {
        return [];
      }

      final List<dynamic> chatHistoryList = json.decode(chatHistoryJson);
      return chatHistoryList
          .map((chatJson) =>
              ChatHistoryModel.fromJson(chatJson as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    } catch (e) {
      throw Exception('Failed to get chat history: $e');
    }
  }

  @override
  Future<List<MessageModel>> getChatMessages(String chatId) async {
    try {
      final messagesJson =
          sharedPreferences.getString('$_messagesKeyPrefix$chatId');
      if (messagesJson == null || messagesJson.isEmpty) {
        return [];
      }

      final List<dynamic> messagesList = json.decode(messagesJson);
      return messagesList
          .map((messageJson) =>
              MessageModel.fromJson(messageJson as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } catch (e) {
      throw Exception('Failed to get chat messages: $e');
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String userId,
    required String text,
    required MessageType type,
  }) async {
    try {
      final messages = await getChatMessages(chatId);

      final newMessage = MessageModel(
        id: _uuid.v4(),
        text: text,
        type: type,
        timestamp: DateTime.now(),
        userId: userId,
        chatId: chatId,
      );

      messages.add(newMessage);

      final messagesJson = json.encode(
        messages.map((message) => message.toJson()).toList(),
      );

      await sharedPreferences.setString(
          '$_messagesKeyPrefix$chatId', messagesJson);

      return newMessage;
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<void> updateChatHistory({
    required String chatId,
    required String lastMessage,
    required DateTime lastMessageTime,
  }) async {
    try {
      final chatHistoryList = await getChatHistory();

      final index = chatHistoryList.indexWhere((chat) => chat.id == chatId);

      if (index != -1) {
        // Update existing chat
        final updatedChat = ChatHistoryModel(
          id: chatHistoryList[index].id,
          user: chatHistoryList[index].user,
          lastMessage: lastMessage,
          lastMessageTime: lastMessageTime,
          unreadCount: chatHistoryList[index].unreadCount,
        );

        chatHistoryList[index] = updatedChat;
      } else {
        return;
      }

      final chatHistoryJson = json.encode(
        chatHistoryList.map((chat) => chat.toJson()).toList(),
      );

      await sharedPreferences.setString(_chatHistoryKey, chatHistoryJson);
    } catch (e) {
      throw Exception('Failed to update chat history: $e');
    }
  }

  Future<void> createChatHistory({
    required String chatId,
    required UserModel user,
    required String lastMessage,
    required DateTime lastMessageTime,
  }) async {
    try {
      final chatHistoryList = await getChatHistory();

      final exists = chatHistoryList.any((chat) => chat.id == chatId);
      if (exists) {
        return;
      }

      final newChat = ChatHistoryModel(
        id: chatId,
        user: user.toEntity(),
        lastMessage: lastMessage,
        lastMessageTime: lastMessageTime,
        unreadCount: 0,
      );

      chatHistoryList.add(newChat);

      final chatHistoryJson = json.encode(
        chatHistoryList.map((chat) => chat.toJson()).toList(),
      );

      await sharedPreferences.setString(_chatHistoryKey, chatHistoryJson);
    } catch (e) {
      throw Exception('Failed to create chat history: $e');
    }
  }
}
