import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/chat_history.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/local/chat_local_datasource.dart';
import '../models/user_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;

  ChatRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<ChatHistory>>> getChatHistory() async {
    try {
      final chatHistory = await localDataSource.getChatHistory();
      return Right(chatHistory.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId) async {
    try {
      final messages = await localDataSource.getChatMessages(chatId);
      return Right(messages.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String chatId,
    required String userId,
    required String text,
  }) async {
    try {
      final message = await localDataSource.sendMessage(
        chatId: chatId,
        userId: userId,
        text: text,
        type: MessageType.sender,
      );
      return Right(message.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateChatHistory({
    required String chatId,
    required String lastMessage,
    required DateTime lastMessageTime,
  }) async {
    try {
      await localDataSource.updateChatHistory(
        chatId: chatId,
        lastMessage: lastMessage,
        lastMessageTime: lastMessageTime,
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createChatHistory({
    required String chatId,
    required User user,
    required String lastMessage,
    required DateTime lastMessageTime,
  }) async {
    try {
      await localDataSource.createChatHistory(
        chatId: chatId,
        user: UserModel.fromEntity(user),
        lastMessage: lastMessage,
        lastMessageTime: lastMessageTime,
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
