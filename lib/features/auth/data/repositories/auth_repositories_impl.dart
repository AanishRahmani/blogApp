// import 'dart:io';

import 'package:blogapp/core/error/exceptions.dart';
import 'package:blogapp/core/error/failures.dart';
import 'package:blogapp/core/network/connection_checker.dart';
import 'package:blogapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blogapp/core/common/entities/user.dart';
import 'package:blogapp/features/auth/data/models/user_model.dart';
import 'package:blogapp/features/auth/domain/repository/aut_repository.dart';
// import 'package:flutter/rendering.dart';
// import 'package:fpdart/src/either.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoriesImpl implements AutRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoriesImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failures, User>> loginInWithEmailPassword({
    // required String name,
    required String password,
    required String email,
  }) async {
    return _getUser(() async => await remoteDataSource.signInWithEmailPassword(
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String name,
    required String password,
    required String email,
  }) async {
    return _getUser(() async => await remoteDataSource.signUpWithEmailPassword(
          name: name,
          email: email,
          password: password,
        ));
  }

  Future<Either<Failures, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures('no internet connection present'));
      }
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUsrSession;

        if (session == null) {
          Failures('user not logged in!!');
        }
        return right(UserModel(
          email: session?.user.id ?? '',
          name: '',
          id: session?.user.id ?? '',
        ));
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(
          Failures('user not logged in!!'),
        );
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
