import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/chat_repository.dart';

class UpdateChatHistoryUseCase {
  final ChatRepository repository;

  UpdateChatHistoryUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String chatId,
    required String lastMessage,
    required DateTime lastMessageTime,
  }) async {
    return await repository.updateChatHistory(
      chatId: chatId,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
    );
  }
}
