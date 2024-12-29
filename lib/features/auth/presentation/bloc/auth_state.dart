// part of 'auth_bloc.dart';

// @immutable
// sealed class AuthState {
//   const AuthState();
// }

// final class AuthInitial extends AuthState {}

// final class AuthLoading extends AuthState {}

// final class AuthSuccess extends AuthState {
//   final User user;

//   const AuthSuccess(this.user);
// }

// final class Authfailure extends AuthState {
//   final String message;

//   const Authfailure(this.message);
// }

part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class Authfailure extends AuthState {
  final String message;
  Authfailure(this.message);
}
