import 'dart:math';
import 'package:billcheck/routes/router_path.dart';
import 'package:billcheck/viewmodel/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _lettersController;

  final String _title = "Bright Laundry";

  @override
  void initState() {
    super.initState();
    final provider = context.read<LoginViewModel>();
    provider.checkLoginStatus();

    // Spinning logo controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Letter drop controller
    _lettersController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    // Navigation after splash
    Future.delayed(const Duration(seconds: 4), () {
      if (provider.user != null) {
        Navigator.pushReplacementNamed(context, RouterPath.dashboard);
      } else {
        Navigator.pushReplacementNamed(context, RouterPath.login);
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _lettersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _lettersController,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotationTransition(
                  turns: _logoController.drive(Tween(begin: 0.0, end: 1.0)),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 160,
                    height: 160,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_title.length, (i) {
                    final char = _title[i];
                    if (char == " ") {
                      return const SizedBox(width: 10); // space between words
                    }

                    final startPosition = -screenHeight * 1;

                    // Staggered interval for each character
                    final start = (i * 0.05).clamp(0.0, 1.0);
                    final end = (start + 0.4).clamp(0.0, 1.0);

                    final animation =
                        Tween<double>(
                              begin:
                                  startPosition, // start above the screen center
                              end: 0, // stop at the bottom of logo
                            )
                            .chain(
                              CurveTween(
                                curve: Interval(
                                  start,
                                  end,
                                  curve: Curves.easeOutBack,
                                ),
                              ),
                            )
                            .animate(_lettersController);

                    return Transform.translate(
                      offset: Offset(0, animation.value),
                      child: Text(
                        char,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          letterSpacing: 1.5,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
