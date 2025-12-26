import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class MessageRepository {
  Future<Either<Failure, String>> fetchRandomMessage();
}
