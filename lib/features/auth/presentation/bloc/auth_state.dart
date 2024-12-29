part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  // const Loader
  // const Loader;
}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class Authfailure extends AuthState {
  final String message;
  Authfailure(this.message);
}
