import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  bool _sent = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final error = Validators.email(_emailController.text);
    if (error != null) {
      AppSnackbar.error(context, error);
      return;
    }
    final auth = context.read<AuthProvider>();
    final success = await auth.sendPasswordReset(_emailController.text.trim());
    if (success && mounted) {
      setState(() => _sent = true);
    } else if (auth.errorMessage != null && mounted) {
      AppSnackbar.error(context, auth.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.15),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  child: _sent ? _buildSuccessView() : _buildFormView(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: 32),
        const Text('🔑', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 20),
        const Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter your email and we\'ll send a reset link.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 36),
        AppTextField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'you@example.com',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
          textInputAction: TextInputAction.done,
          onEditingComplete: _handleSend,
        ),
        const SizedBox(height: 32),
        Consumer<AuthProvider>(
          builder: (_, auth, __) => AppButton(
            label: 'Send Reset Link',
            isLoading: auth.isLoading,
            onTap: _handleSend,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, Routes.login),
            child: const Text(
              'Back to Sign In',
              style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('📬', style: TextStyle(fontSize: 64)),
        const SizedBox(height: 24),
        const Text(
          'Check your inbox!',
          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'We sent a reset link to\n${_emailController.text.trim()}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 40),
        AppButton(
          label: 'Back to Sign In',
          onTap: () => Navigator.pushReplacementNamed(context, Routes.login),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _sent = false),
          child: const Text(
            'Try a different email',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
