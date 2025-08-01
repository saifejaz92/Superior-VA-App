import 'package:flutter/material.dart';
import 'package:superior_va_app/utils/custom_btn.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'Superior VA',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A28CB),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Please sign up using the form below',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Name'),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Email'),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Loisbecket@gmail.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Password'),
                    Text(
                      'Forget Password?',
                      style: TextStyle(
                        color: Color(0xFF7A28CB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.visibility_off),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(value: false, onChanged: (value) {}),
                    const Text('Remember me'),
                  ],
                ),
                const SizedBox(height: 12),
                const GradientButton(text: 'Sign In'),
                const SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: const TextSpan(
                      text: "Do you have already account? ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: Color(0xFF7A28CB),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
