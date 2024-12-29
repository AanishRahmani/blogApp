import 'package:blogapp/core/common/widgets/loader.dart';
import 'package:blogapp/core/common/widgets/show_snackbar.dart';
import 'package:blogapp/core/theme/app_pallete.dart';
import 'package:blogapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/features/auth/presentation/pages/signup_page.dart';
import 'package:blogapp/features/auth/presentation/widgets/auth_feild.dart';
import 'package:blogapp/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class SigninPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SigninPage());

  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _emailController = TextEditingController();
  // final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authfailure) {
              showSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              Loader;
            }

            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In.',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // AuthFeild(
                  //   hintText: 'Name',
                  //   controller: _nameController,
                  //   // isObscureText: false,
                  // ),
                  const SizedBox(height: 15),
                  AuthFeild(
                    hintText: 'email',
                    controller: _emailController,
                    // isObscureText: false,
                  ),
                  const SizedBox(height: 15),
                  AuthFeild(
                    hintText: 'password',
                    controller: _passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 15),
                  AuthGradientButton(
                    buttonText: 'sign In',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(AuthLogin(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              // name: '',
                            ));
                        log('message sent ');
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, SignupPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: ' Sign Up',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppPallete.gradient2,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )
                          ],
                          text: 'Don\'t have an account?',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
