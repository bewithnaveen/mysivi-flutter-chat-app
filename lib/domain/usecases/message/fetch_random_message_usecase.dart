import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/message_repository.dart';

class FetchRandomMessageUseCase {
  final MessageRepository repository;

  FetchRandomMessageUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.fetchRandomMessage();
  }
}
