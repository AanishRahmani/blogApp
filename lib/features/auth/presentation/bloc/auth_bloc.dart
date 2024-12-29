import 'dart:developer';
// import 'dart:math';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/features/auth/domain/entities/user.dart';
import 'package:blogapp/features/auth/domain/usecases/current_user.dart';
import 'package:blogapp/features/auth/domain/usecases/user_login.dart';
import 'package:blogapp/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignup);
    on<AuthLogin>(_onAuthLogin);
    on<authIsUserLoggedIn>(_isUserLoggedIn);
  }

// update is logged in
  void _isUserLoggedIn(
    authIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) {
        log('AuthBloc: Login/Signup failed with error: ${l.message}');
        emit(Authfailure(l.message));
      },
      (user) {
        log('AuthBloc:(trying to persist) Preparing to emit AuthSuccess for user: ${user.id}');

        emit(AuthSuccess(user)); // Emitting the success state

        log('AuthBloc: AuthSuccess from memory emitted successfully for user(persisted): ${user.id}');
      },
    );
  }

  // Sign-up function
  void _onAuthSignup(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    log('AuthBloc: Starting sign-up process for ${event.email}');
    try {
      final res = await _userSignUp(
        UserSignUpParams(
          email: event.email,
          password: event.password,
          name: event.name,
        ),
      );

      res.fold(
        (failure) {
          log('AuthBloc: Sign-up failed with error: ${failure.message}');
          emit(Authfailure(failure.message));
        },
        (user) {
          log('AuthBloc: Sign-up successful for UID: $user');
          emit(AuthSuccess(user));
        },
      );
    } catch (e) {
      log('AuthBloc: Exception occurred during sign-up: $e');
      emit(Authfailure('Unexpected error: $e'));
    }
  }

  // Login function
  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    log('AuthBloc: Starting login process for ${event.email}');
    try {
      final res = await _userLogin(
        UserLoginParams(
          email: event.email,
          password: event.password,
        ),
      );

      res.fold(
        (failure) {
          log('AuthBloc: Login failed with error: ${failure.message}');
          emit(Authfailure(failure.message));
        },
        (user) {
          log('AuthBloc: Login successful for UID: $user');
          emit(AuthSuccess(user));
        },
      );
    } catch (e) {
      log('AuthBloc: Exception occurred during login: $e');
      emit(Authfailure('Unexpected error: $e'));
    }
  }
}
