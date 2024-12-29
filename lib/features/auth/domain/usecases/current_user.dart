import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/core/common/entities/user.dart';
import 'package:blogapp/features/auth/domain/repository/aut_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AutRepository autRepository;

  CurrentUser(this.autRepository);
  @override
  Future<Either<Failures, User>> call(NoParams params) async {
    return await autRepository.currentUser();
  }
}
