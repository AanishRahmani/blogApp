import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/features/auth/domain/entities/user.dart';
import 'package:blogapp/features/auth/domain/repository/aut_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements Usecase<User, UserSignUpParams> {
  final AutRepository autRepository;

  UserSignUp({required this.autRepository});
  @override
  Future<Either<Failures, User>> call(UserSignUpParams params) async {
    return await autRepository.signUpWithEmailPassword(
      name: params.name,
      password: params.password,
      email: params.email,
    );
  }
}

class UserSignUpParams {
  // created a class so that we can pass success in  UserSignUp
  final String email;
  final String password;
  final String name;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
