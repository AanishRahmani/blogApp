import 'package:blogapp/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _border({Color color = AppPallete.borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        width: 3,
        color: color,
      ),
    );
  }

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(backgroundColor: AppPallete.backgroundColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(color: AppPallete.gradient2),
      errorBorder: _border(color: AppPallete.errorColor),
    ),
    chipTheme: ChipThemeData(
      color: WidgetStateProperty.all(AppPallete.backgroundColor),
      side: BorderSide.none,
    ),
  );
}
