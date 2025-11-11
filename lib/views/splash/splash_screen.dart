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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final provider = context.read<LoginViewModel>();
    provider.checkLoginStatus();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // continuous spin
    Future.delayed(const Duration(seconds: 3), () {
      if (provider.user != null) {
        // User already logged in
        Navigator.pushReplacementNamed(context, RouterPath.dashboard);
      } else {
        // User not logged in
        Navigator.pushReplacementNamed(context, RouterPath.login);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: RotationTransition(
          turns: _controller.drive(Tween(begin: 0.0, end: 1.0)),
          child: Image.asset('assets/images/logo.png', width: 160, height: 160),
        ),
      ),
    );
  }
}
