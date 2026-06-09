import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreedToTerms  = false;

  late AnimationController _animController;
  late Animation<double>  _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final nameErr  = Validators.name(_nameController.text);
    final emailErr = Validators.email(_emailController.text);
    final passErr  = Validators.password(_passwordController.text);

    if (nameErr != null)  { AppSnackbar.error(context, nameErr);  return; }
    if (emailErr != null) { AppSnackbar.error(context, emailErr); return; }
    if (passErr != null)  { AppSnackbar.error(context, passErr);  return; }
    if (!_agreedToTerms)  {
      AppSnackbar.error(context, 'Please agree to the Terms of Service');
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      AppSnackbar.success(context, 'Account created! Let\'s set up your style.');
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.gender);
      }
    } else {
      AppSnackbar.error(context, auth.errorMessage ?? 'Registration failed.');
      auth.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(bottom: -100, left: -60,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.gradientEnd.withOpacity(0.25),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 24),
                    const Text('Create Account ✨',
                        style: TextStyle(color: Colors.white, fontSize: 30,
                            fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                    const SizedBox(height: 8),
                    const Text('Join thousands styling smarter with AI',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
                    const SizedBox(height: 36),

                    AppTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Your display name',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: Validators.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'you@example.com',
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Min. 8 characters',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      validator: Validators.password,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: _handleRegister,
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
                    const SizedBox(height: 16),
                    _PasswordStrengthBar(password: _passwordController.text),
                    const SizedBox(height: 24),

                    // Terms checkbox
                    GestureDetector(
                      onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              color: _agreedToTerms
                                  ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _agreedToTerms
                                    ? AppColors.primary : const Color(0xFF3A3A5A),
                                width: 1.5,
                              ),
                            ),
                            child: _agreedToTerms
                                ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 14)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'I agree to the Terms of Service and Privacy Policy',
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    Consumer<AuthProvider>(
                      builder: (_, auth, __) => AppButton(
                        label: 'Create Account',
                        onTap: _handleRegister,
                        isLoading: auth.isLoading,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Center(
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, Routes.login),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  final String password;
  const _PasswordStrengthBar({required this.password});

  int get _strength {
    if (password.length < 4) return 0;
    if (password.length < 6) return 1;
    if (password.length < 8) return 2;
    if (password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]'))) {
      return 4;
    }
    return 3;
  }

  Color get _color {
    switch (_strength) {
      case 1: return Colors.redAccent;
      case 2: return Colors.orange;
      case 3: return Colors.yellow;
      case 4: return AppColors.success;
      default: return AppColors.surfaceLight;
    }
  }

  String get _label {
    switch (_strength) {
      case 1: return 'Weak';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Strong 🔒';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) => Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 4),
              height: 4,
              decoration: BoxDecoration(
                color: i < _strength ? _color : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          )),
        ),
        if (_label.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(_label,
              style: TextStyle(
                  color: _color, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ],
    );
  }
}
