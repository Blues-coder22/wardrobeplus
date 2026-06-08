import 'package:flutter/material.dart';
import '../components/custom_buttons.dart';

class RegistrationScreen extends StatelessWidget {
  final VoidCallback onRegisterSuccess;
  const RegistrationScreen({super.key, required this.onRegisterSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            const TextField(decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 32),
            PrimaryBrandButton(text: 'Sign Up', onPressed: onRegisterSuccess),
          ],
        ),
      ),
    );
  }
}