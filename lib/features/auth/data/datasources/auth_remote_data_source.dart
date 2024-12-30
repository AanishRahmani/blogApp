import 'package:blogapp/core/error/exceptions.dart';
import 'package:blogapp/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

abstract interface class AuthRemoteDataSource {
  Session? get currentUsrSession;

  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      log('AuthRemoteDataSource: Attempting to sign in user with email: $email');
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        log('AuthRemoteDataSource: Sign-in failed, user is null');
        throw ServerException('User is null');
      }

      log('AuthRemoteDataSource: Sign-in successful for user ID: ${response.user!.id}');
      return UserModel.fromJson(response.user!.toJson()).copyWith(
        email: currentUsrSession!.user.email,
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      log('AuthRemoteDataSource: Error during sign-in: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      log('AuthRemoteDataSource: Attempting to sign up user with email: $email');
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );
      if (response.user == null) {
        log('AuthRemoteDataSource: Sign-up failed, user is null');
        throw ServerException('User is null');
      }

      log('AuthRemoteDataSource: Sign-up successful for user ID: ${response.user!.id}');
      return UserModel.fromJson(response.user!.toJson())
        ..copyWith(
          email: currentUsrSession!.user.email,
        );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      log('AuthRemoteDataSource: Error during sign-up: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Session? get currentUsrSession {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) {
        log('AuthRemoteDataSource: No active session found');
      } else {
        log('AuthRemoteDataSource: Active session found for user ID: ${session.user.id}');
      }
      return session;
    } catch (e) {
      log('AuthRemoteDataSource: Error retrieving current session: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      log('AuthRemoteDataSource: Fetching current user data');
      final session = currentUsrSession;

      if (session == null) {
        log('AuthRemoteDataSource: No active session, unable to fetch user data');
        return null;
      }

      final userData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', session.user.id)
          .single();

      log('AuthRemoteDataSource: Successfully fetched user data for user ID: ${session.user.id}');
      return UserModel.fromJson(userData).copyWith(
        email: session.user.email,
      );
    } catch (e) {
      log('AuthRemoteDataSource: Error fetching current user data: $e');
      throw ServerException(e.toString());
    }
  }
}
