// import 'dart:developer';
import 'package:blogapp/core/theme/theme.dart';
// import 'package:blogapp/features/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:blogapp/features/auth/data/repositories/auth_repositories_impl.dart';
// import 'package:blogapp/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blogapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/features/auth/presentation/pages/signin_page.dart';
import 'package:blogapp/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:blogapp/core/secrets/app_secrets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();
  // try {
  //   // Initialize Supabase
  //   await Supabase.initialize(
  //     url: AppSecrets.supabaseUrl,
  //     anonKey: AppSecrets.supabaseAnonKey,
  //   );

  // Get SupabaseClient instance
  // final supabaseClient = Supabase.instance.client;

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        // create: (_) => AuthBloc(
        //   userSignUp: UserSignUp(
        //     autRepository: AuthRepositoriesImpl(
        //       AuthRemoteDataSourceImpl(supabaseClient: supabaseClient),
        //     ),
        //   ),
        // ),
        create: (_) => serviceLocator<AuthBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
//   } catch (e) {
//     // Log error and exit if Supabase fails to initialize
//     log('Error initializing Supabase: $e');
//     return;
//   }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(authIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: const SigninPage(),
    );
  }
}
