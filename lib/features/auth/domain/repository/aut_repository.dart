import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AutRepository {
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String name,
    required String password,
    required String email,
  });
  Future<Either<Failures, User>> loginInWithEmailPassword({
    // required String name,
    required String password,
    required String email,
  });

  Future<Either<Failures, User>> currentUser();
}
