import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/chat_repository.dart';

class CreateChatHistoryUseCase {
  final ChatRepository repository;

  CreateChatHistoryUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String chatId,
    required User user,
    required String lastMessage,
    required DateTime lastMessageTime,
  }) async {
    return await repository.createChatHistory(
      chatId: chatId,
      user: user,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
    );
  }
}
