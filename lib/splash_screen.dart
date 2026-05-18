import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'services/biometric_service.dart';
import 'services/biometric_preferences.dart';

import 'home_page.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _logoController;
  late AnimationController _textController;

  late Animation<double>
  _logoScaleAnimation;

  late Animation<double>
  _logoRotationAnimation;

  late Animation<double>
  _textScaleAnimation;

  late Animation<double>
  _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _logoController =
        AnimationController(
          vsync: this,
          duration:
          const Duration(
            milliseconds: 1800,
          ),
        );

    _textController =
        AnimationController(
          vsync: this,
          duration:
          const Duration(
            milliseconds: 1000,
          ),
        );

    _logoScaleAnimation =
        Tween<double>(
          begin: 0.5,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _logoController,
            curve: Curves.easeOutBack,
          ),
        );

    _logoRotationAnimation =
        Tween<double>(
          begin: math.pi / 2,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: _logoController,
            curve: Curves.easeOutExpo,
          ),
        );

    _textScaleAnimation =
        Tween<double>(
          begin: 0.5,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _textController,
            curve: Curves.easeOutBack,
          ),
        );

    _textOpacityAnimation =
        Tween<double>(
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
  // START ANIMATION
  // =========================
  Future<void>
  startAnimation() async {

    await _logoController.forward();

    await _textController.forward();

    await Future.delayed(
      const Duration(seconds: 1),
    );

    bool biometricEnabled =
    await BiometricPreferences
        .isBiometricEnabled();

    final user =
        FirebaseAuth.instance.currentUser;

    if (mounted) {

      // USER EXISTS
      if (user != null) {

        // BIOMETRIC ENABLED
        if (biometricEnabled) {

          bool authenticated =
          await BiometricService
              .authenticate();

          if (authenticated) {

            Navigator.pushReplacement(
              context,

              MaterialPageRoute(
                builder: (context) =>
                const HomePage(),
              ),
            );
          }

          else {

            Navigator.pushReplacement(
              context,

              MaterialPageRoute(
                builder: (context) =>
                const LoginPage(),
              ),
            );
          }
        }

        // BIOMETRIC DISABLED
        else {

          Navigator.pushReplacement(
            context,

            MaterialPageRoute(
              builder: (context) =>
              const HomePage(),
            ),
          );
        }
      }

      // USER NOT LOGGED IN
      else {

        Navigator.pushReplacement(
          context,

          MaterialPageRoute(
            builder: (context) =>
            const LoginPage(),
          ),
        );
      }
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
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            AnimatedBuilder(
              animation:
              _logoController,

              builder:
                  (
                  context,
                  child,
                  ) {

                return Transform.rotate(
                  angle:
                  _logoRotationAnimation
                      .value,

                  child: Transform.scale(
                    scale:
                    _logoScaleAnimation
                        .value,

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

            FadeTransition(
              opacity:
              _textOpacityAnimation,

              child: ScaleTransition(
                scale:
                _textScaleAnimation,

                child: Column(
                  children: [

                    const Text(
                      "SecureNest",

                      style: TextStyle(
                        fontSize: 34,
                        fontWeight:
                        FontWeight.bold,

                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      "Your trusted Haven",

                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight:
                        FontWeight.w400,
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