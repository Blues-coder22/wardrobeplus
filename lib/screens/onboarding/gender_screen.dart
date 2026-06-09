import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_button.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select your gender identity',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'This helps us suggest the best clothing categories for you.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              _buildGenderCard('Male', Icons.male),
              const SizedBox(height: 16),
              _buildGenderCard('Female', Icons.female),
              const SizedBox(height: 16),
              _buildGenderCard('Other', Icons.person_outline),
              const Spacer(),
              AppButton(
                label: 'Continue',
                isEnabled: _selectedGender != null,
                onTap: () async {
                  await context.read<AuthProvider>().saveGender(_selectedGender!);
                  if (mounted) {
                    Navigator.pushNamed(context, Routes.bodyQuiz);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : Colors.white),
            const SizedBox(width: 16),
            Text(
              gender,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : Colors.white,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
