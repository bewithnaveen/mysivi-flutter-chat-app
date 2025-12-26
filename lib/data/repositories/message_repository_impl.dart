import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/remote/message_remote_datasource.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> fetchRandomMessage() async {
    try {
      final message = await remoteDataSource.fetchRandomMessage();
      return Right(message);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
