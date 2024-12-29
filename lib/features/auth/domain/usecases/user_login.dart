import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/features/auth/domain/entities/user.dart';
import 'package:blogapp/features/auth/domain/repository/aut_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements Usecase<User, UserLoginParams> {
  final AutRepository autRepository;

  UserLogin(this.autRepository);
  @override
  Future<Either<Failures, User>> call(UserLoginParams params) async {
    return await autRepository.loginInWithEmailPassword(
      password: params.password,
      email: params.email,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}
