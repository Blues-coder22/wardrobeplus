import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double>  _fadeAnim;
  late Animation<Offset>  _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim  = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validate fields first
    final emailErr = Validators.email(_emailController.text);
    if (emailErr != null) { AppSnackbar.error(context, emailErr); return; }
    if (_passwordController.text.isEmpty) {
      AppSnackbar.error(context, 'Password is required'); return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Check if they finished onboarding
      if (!auth.hasCompletedOnboarding) {
        Navigator.pushReplacementNamed(context, Routes.gender);
      } else {
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    } else {
      AppSnackbar.error(context, auth.errorMessage ?? 'Sign in failed.');
      auth.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -80, right: -60,
              child: _orb(240, AppColors.primary, 0.3)),
          Positioned(top: 80, left: -80,
              child: _orb(200, AppColors.accent, 0.2)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      _logo(),
                      const SizedBox(height: 48),
                      const Text('Welcome Back 👋',
                          style: TextStyle(color: Colors.white, fontSize: 30,
                              fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                      const SizedBox(height: 8),
                      const Text('Sign in to manage your style collection',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                      const SizedBox(height: 40),

                      // Social buttons
                      _socialButton('Continue with Google', Icons.g_mobiledata),
                      const SizedBox(height: 12),
                      _socialButton('Continue with Apple', Icons.apple),
                      const SizedBox(height: 28),
                      _divider(),
                      const SizedBox(height: 28),

                      // Email
                      AppTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'you@example.com',
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: _handleLogin,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted, size: 20,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, Routes.forgotPassword),
                          child: const Text('Forgot password?',
                              style: TextStyle(color: AppColors.primary,
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // CTA — driven by AuthProvider
                      Consumer<AuthProvider>(
                        builder: (_, auth, __) => AppButton(
                          label: 'Sign In',
                          onTap: _handleLogin,
                          isLoading: auth.isLoading,
                        ),
                      ),
                      const SizedBox(height: 28),

                      Center(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, Routes.register),
                          child: RichText(
                            text: const TextSpan(
                              text: "New here? ",
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Create an account',
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logo() => Row(
    children: [
      Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.gradientEnd]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.style, color: Colors.white, size: 24),
      ),
      const SizedBox(width: 10),
      const Text('Wardrobe+',
          style: TextStyle(color: Colors.white, fontSize: 20,
              fontWeight: FontWeight.w800)),
    ],
  );

  Widget _orb(double size, Color color, double opacity) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
          colors: [color.withOpacity(opacity), Colors.transparent]),
    ),
  );

  Widget _socialButton(String label, IconData icon) => GestureDetector(
    onTap: () {},
    child: Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A4A)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(color: Colors.white,
                  fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );

  Widget _divider() => const Row(
    children: [
      Expanded(child: Divider(color: Color(0xFF2A2A4A))),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('or continue with email',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ),
      Expanded(child: Divider(color: Color(0xFF2A2A4A))),
    ],
  );
}
