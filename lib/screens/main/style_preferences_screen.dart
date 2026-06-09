import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_button.dart';

class StylePreferencesScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const StylePreferencesScreen({super.key, this.onBack});

  @override
  State<StylePreferencesScreen> createState() => _StylePreferencesScreenState();
}

class _StylePreferencesScreenState extends State<StylePreferencesScreen> {
  String? _selectedStyle;
  final List<String> _additionalStyles = [];

  final List<Map<String, String>> _styles = [
    {'id': 'minimalist', 'label': 'Minimalist', 'emoji': '🤍'},
    {'id': 'streetwear', 'label': 'Streetwear', 'emoji': '🧢'},
    {'id': 'vintage', 'label': 'Vintage Academic', 'emoji': '📚'},
    {'id': 'techwear', 'label': 'Techwear', 'emoji': '⚡'},
    {'id': 'afro-chic', 'label': 'Afro-Chic', 'emoji': '🌍'},
    {'id': 'business', 'label': 'Business Casual', 'emoji': '💼'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    onPressed: widget.onBack ?? () => Navigator.pop(context),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Define your style 👗',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pick your primary style. This helps our AI recommend the best outfits for you.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _styles.length,
                  itemBuilder: (context, i) {
                    final style = _styles[i];
                    final isSelected = _selectedStyle == style['id'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedStyle = style['id']),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : const Color(0xFF2A2A4A),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(style['emoji']!, style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 8),
                            Text(
                              style['label']!,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              AppButton(
                label: 'Finish Setup',
                isEnabled: _selectedStyle != null,
                onTap: () async {
                  await context.read<AuthProvider>().saveStylePreferences(
                        primaryStyle: _selectedStyle!,
                        additionalStyles: _additionalStyles,
                      );
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
