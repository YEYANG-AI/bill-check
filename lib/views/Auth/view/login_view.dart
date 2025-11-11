import 'package:billcheck/routes/router_path.dart';
import 'package:billcheck/viewmodel/login_view_model.dart';
import 'package:billcheck/views/Auth/widget/login_button.dart';
import 'package:billcheck/views/Auth/widget/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<LoginViewModel>(context, listen: false);
      await provider.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (provider.user != null) {
        if (mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(RouterPath.dashboard, (route) => false);
        }
      } else if (provider.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error!), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(160),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 160,
                    height: 160,
                  ),
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Text(
                        "BRIGHT",
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 56,
                      left: 16,
                      child: Text(
                        "LAUNDRY",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                LoginTextFields(
                  emailController: emailController,
                  passwordController: passwordController,
                ),
                const SizedBox(height: 30),
                LoginButton(onTap: _submit, isLoading: provider.isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
