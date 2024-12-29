import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message,
    {String? actionLabel, VoidCallback? onAction}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 10),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.yellowAccent,
                onPressed: onAction ?? () {},
              )
            : null,
        behavior: SnackBarBehavior
            .floating, // Makes the Snackbar float above other UI.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16), // Adds spacing around the Snackbar.
        elevation: 6,
      ),
    );
}
