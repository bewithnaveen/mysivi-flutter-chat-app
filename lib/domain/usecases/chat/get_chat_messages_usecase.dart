import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';

class GetChatMessagesUseCase {
  final ChatRepository repository;

  GetChatMessagesUseCase(this.repository);

  Future<Either<Failure, List<Message>>> call(String chatId) async {
    return await repository.getChatMessages(chatId);
  }
}
