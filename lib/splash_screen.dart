import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _logoController;
  late AnimationController _textController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;

  late Animation<double> _textScaleAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // =========================
    // LOGO ANIMATION CONTROLLER
    // =========================
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // =========================
    // TEXT ANIMATION CONTROLLER
    // =========================
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // =========================
    // LOGO SCALE
    // 0.5 -> 1
    // =========================
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );

    // =========================
    // LOGO ROTATION
    // 90deg -> 0deg
    // =========================
    _logoRotationAnimation = Tween<double>(
      begin: math.pi / 2,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutExpo,
      ),
    );

    // =========================
    // TEXT SCALE
    // 0.5 -> 1
    // =========================
    _textScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutBack,
      ),
    );

    // =========================
    // TEXT FADE
    // =========================
    _textOpacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    startAnimation();
  }

  // =========================
  // START ANIMATION SEQUENCE
  // =========================
  Future<void> startAnimation() async {

    // Start logo animation
    await _logoController.forward();

    // Start text animation
    await _textController.forward();

    // Wait before navigation
    await Future.delayed(const Duration(seconds: 1));

    // Navigate to Login Page
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // =========================
            // ANIMATED LOGO
            // =========================
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _logoRotationAnimation.value,
                  child: Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/images/RSIcon.png',
                height: 230,
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // ANIMATED TEXTS
            // =========================
            FadeTransition(
              opacity: _textOpacityAnimation,
              child: ScaleTransition(
                scale: _textScaleAnimation,
                child: Column(
                  children: [

                    // App Name
                    const Text(
                      "SecureNest",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      "Your trusted Haven",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}