part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: AppSecrets.supabaseUrl,
      anonKey: AppSecrets.supabaseAnonKey,
    );
    serviceLocator.registerLazySingleton(() => Supabase.instance.client);
    log('Supabase initialized successfully');

    serviceLocator.registerFactory(() => InternetConnection());

    // Core dependencies
    serviceLocator.registerLazySingleton(() => AppUserCubit());

    serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(
        serviceLocator(),
      ),
    );

    // Initialize Authentication-related dependencies
    _initAuth();

    // Initialize Blog-related dependencies
    _initBlog();
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

    // Register AutRepository
    serviceLocator.registerFactory<AutRepository>(
      () => AuthRepositoriesImpl(
        serviceLocator<AuthRemoteDataSource>(),
        serviceLocator(),
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
        appUserCubit: serviceLocator<AppUserCubit>(),
      ),
    );

    log('Authentication dependencies initialized successfully');
  } catch (e) {
    log('Error initializing authentication dependencies: $e');
    rethrow; // Allow the error to propagate if needed
  }
}

void _initBlog() {
  // Register Blog-related dependencies
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogRepository>(() => BlogRepositoryImpl(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ))
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );

  log('Blog dependencies initialized successfully');
}
