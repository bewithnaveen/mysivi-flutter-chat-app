import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/user_local_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final users = await localDataSource.getUsers();
      return Right(users.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> addUser(String name) async {
    try {
      final user = await localDataSource.addUser(name);
      return Right(user.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(String id) async {
    try {
      final user = await localDataSource.getUserById(id);
      if (user == null) {
        return const Left(CacheFailure('User not found'));
      }
      return Right(user.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
