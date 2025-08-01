import 'package:flutter/material.dart';
import 'package:superior_va_app/screens/image_gen_screens/text_to_image_screen.dart';
import 'package:superior_va_app/screens/post_generator/post_generation_screen.dart';
import 'package:superior_va_app/utils/custom_btn.dart';

class FnSelectorScreen extends StatelessWidget {
  const FnSelectorScreen({super.key});

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
                text: 'Text to Image Generator',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AiTextToImageGenerator(),
                    ),
                  );
                },
              ),
              SizedBox(height: 40),
              GradientButton(
                text: 'Post Generator',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostGenerateScreen(),
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
