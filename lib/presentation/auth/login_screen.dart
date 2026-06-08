import 'package:flutter/material.dart';
import '../components/custom_buttons.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onNavigateToRegister;
  const LoginScreen({super.key, required this.onLoginSuccess, required this.onNavigateToRegister});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('Sign in to manage your collection layout', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            const TextField(decoration: InputDecoration(labelText: 'Email Address', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 32),
            PrimaryBrandButton(text: 'Sign In', onPressed: onLoginSuccess),
            Center(
              child: TextButton(
                onPressed: onNavigateToRegister,
                child: const Text('New here? Create an account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}