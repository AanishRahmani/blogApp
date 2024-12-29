import 'dart:developer';
import 'package:blogapp/core/secrets/app_secrets.dart';
import 'package:blogapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blogapp/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:blogapp/features/auth/domain/repository/aut_repository.dart';
import 'package:blogapp/features/auth/domain/usecases/current_user.dart';
import 'package:blogapp/features/auth/domain/usecases/user_login.dart';
import 'package:blogapp/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blogapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: AppSecrets.supabaseUrl,
      anonKey: AppSecrets.supabaseAnonKey,
    );
    serviceLocator.registerLazySingleton(() => Supabase.instance.client);
    log('Supabase initialized successfully');

    // Initialize Authentication-related dependencies
    _initAuth();
  } catch (e) {
    log('Error initializing dependencies: $e');
    rethrow; // Allow the error to propagate if needed
  }
}

void _initAuth() {
  try {
    // Register AuthRemoteDataSource
    serviceLocator.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator<SupabaseClient>(),
      ),
    );

    // Register AuthRepository
    serviceLocator.registerFactory<AutRepository>(
      () => AuthRepositoriesImpl(
        serviceLocator<AuthRemoteDataSource>(),
      ),
    );

    // Register UserSignUp use case
    serviceLocator.registerFactory(
      () => UserSignUp(
        autRepository: serviceLocator<AutRepository>(),
      ),
    );

    // Register UserLogin use case
    serviceLocator.registerFactory(
      () => UserLogin(
        serviceLocator<AutRepository>(),
      ),
    );

    serviceLocator.registerFactory(() => CurrentUser(serviceLocator()));

    // Register AuthBloc
    serviceLocator.registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userLogin: serviceLocator<UserLogin>(),
        currentUser: serviceLocator<CurrentUser>(),
      ),
    );

    log('Authentication dependencies initialized successfully');
  } catch (e) {
    log('Error initializing authentication dependencies: $e');
    rethrow; // Allow the error to propagate if needed
  }
}
