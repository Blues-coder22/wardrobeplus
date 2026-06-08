import 'package:flutter/material.dart';
import '../components/custom_buttons.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onNext;
  const OnboardingScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: const Color(0xFFEAE8FF), borderRadius: BorderRadius.circular(32)),
              child: const Text('✨', style: TextStyle(fontSize: 64)),
            ),
            const SizedBox(height: 40),
            Text('Wardrobe+', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            const SizedBox(height: 12),
            const Text(
              'Your AI-powered digital closet. Organize layouts, track items, and style smart outfits cleanly.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 48),
            PrimaryBrandButton(text: 'Get Started', onPressed: onNext),
          ],
        ),
      ),
    );
  }
}