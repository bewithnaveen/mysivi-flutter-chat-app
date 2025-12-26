import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/message.dart';
import '../../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, Message>> call({
    required String chatId,
    required String userId,
    required String text,
  }) async {
    if (text.trim().isEmpty) {
      return const Left(CacheFailure('Message cannot be empty'));
    }
    return await repository.sendMessage(
      chatId: chatId,
      userId: userId,
      text: text,
    );
  }
}
