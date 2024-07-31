import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Set the background color
      body: AnimatedSplashScreen(
        backgroundColor: Colors.black54,
        splash: Center(
          child: Lottie.asset(
            'assets/lottie/quote_animation.json',
            fit: BoxFit.cover, // Make Lottie animation cover the entire area
          ),
        ),
        splashIconSize: double.infinity, // Full screen size
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: const HomeScreen(),
      ),
    );
  }
}
