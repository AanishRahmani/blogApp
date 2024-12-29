// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:blogapp/core/theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  const AuthGradientButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(colors: [
          AppPallete.gradient1,
          AppPallete.gradient2,
        ], begin: Alignment.bottomLeft, end: Alignment.topRight),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
          fixedSize: const Size(395, 55),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: AppPallete.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
