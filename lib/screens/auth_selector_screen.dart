import 'package:flutter/material.dart';
import 'package:superior_va_app/screens/auth_screens/login_screen.dart';
import 'package:superior_va_app/screens/auth_screens/signup_screen.dart';
import 'package:superior_va_app/utils/custom_btn.dart';

class AuthSelectorScreen extends StatelessWidget {
  const AuthSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img/VA logo.png'),
              SizedBox(height: 20),
              GradientButton(
                text: 'Signup',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 40),
              GradientButton(
                text: 'Signin',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
