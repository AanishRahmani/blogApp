import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 2 * 3.14159),
        duration: const Duration(seconds: 2),
        onEnd: () {
          // Loop the animation by restarting it automatically
        },
        builder: (context, angle, child) {
          return Transform.rotate(
            angle: angle,
            child: const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
