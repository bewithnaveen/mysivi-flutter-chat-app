import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/chat_history.dart';
import '../entities/message.dart';
import '../entities/user.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatHistory>>> getChatHistory();
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId);
  Future<Either<Failure, Message>> sendMessage({
    required String chatId,
    required String userId,
    required String text,
  });
  Future<Either<Failure, void>> updateChatHistory({
    required String chatId,
    required String lastMessage,
    required DateTime lastMessageTime,
  });
  Future<Either<Failure, void>> createChatHistory({
    required String chatId,
    required User user,
    required String lastMessage,
    required DateTime lastMessageTime,
  });
}
