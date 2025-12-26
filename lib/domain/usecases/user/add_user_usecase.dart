import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class AddUserUseCase {
  final UserRepository repository;

  AddUserUseCase(this.repository);

  Future<Either<Failure, User>> call(String name) async {
    if (name.trim().isEmpty) {
      return const Left(CacheFailure('Name cannot be empty'));
    }
    return await repository.addUser(name);
  }
}
