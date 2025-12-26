import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/chat_history.dart';
import '../../repositories/chat_repository.dart';

class GetChatHistoryUseCase {
  final ChatRepository repository;

  GetChatHistoryUseCase(this.repository);

  Future<Either<Failure, List<ChatHistory>>> call() async {
    return await repository.getChatHistory();
  }
}
