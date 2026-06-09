import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../models/body_type_model.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

/// Step 2 of onboarding. Body type and measurements are BOTH optional —
/// users can pick a body type, enter measurements, both, or skip entirely
/// and go straight to the style selector.
class BodyTypeQuizScreen extends StatefulWidget {
  const BodyTypeQuizScreen({super.key});

  @override
  State<BodyTypeQuizScreen> createState() => _BodyTypeQuizScreenState();
}

enum _InputMode { bodyType, measurements }

class _BodyTypeQuizScreenState extends State<BodyTypeQuizScreen>
    with TickerProviderStateMixin {
  String? _selectedBodyType;
  _InputMode _mode = _InputMode.bodyType;
  bool _isLoading = false;

  // Measurement controllers
  final _heightController = TextEditingController();
  final _bustController   = TextEditingController();
  final _waistController  = TextEditingController();
  final _hipsController   = TextEditingController();
  String _unit = 'cm';

  late AnimationController _slideController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _slideController, curve: Curves.easeOut);
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _heightController.dispose();
    _bustController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    super.dispose();
  }

  void _switchMode(_InputMode mode) {
    if (_mode == mode) return;
    HapticFeedback.selectionClick();
    _slideController.reset();
    setState(() => _mode = mode);
    _slideController.forward();
  }

  bool get _hasMeasurementInput =>
      _heightController.text.trim().isNotEmpty ||
          _bustController.text.trim().isNotEmpty ||
          _waistController.text.trim().isNotEmpty ||
          _hipsController.text.trim().isNotEmpty;

  double? _parse(String text) => double.tryParse(text.trim());

  BodyMeasurements get _measurements => BodyMeasurements(
    heightCm: _parse(_heightController.text),
    bustChestCm: _parse(_bustController.text),
    waistCm: _parse(_waistController.text),
    hipsCm: _parse(_hipsController.text),
    unit: _unit,
  );

  Future<void> _saveAndContinue({required bool skip}) async {
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();

    if (!skip) {
      if (_mode == _InputMode.bodyType && _selectedBodyType != null) {
        await auth.saveBodyType(_selectedBodyType!);
      } else if (_mode == _InputMode.measurements && _hasMeasurementInput) {
        await auth.saveMeasurements(_measurements);
      }
    } else {
      await auth.skipBodyType();
    }

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, Routes.styleSelector);
    }
  }

  bool get _canContinue {
    if (_mode == _InputMode.bodyType) return _selectedBodyType != null;
    return _hasMeasurementInput;
  }

  @override
  Widget build(BuildContext context) {
    final gender = context.watch<AuthProvider>().user.gender;
    final bodyTypes = BodyTypeCatalog.forGender(gender);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────────
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF2A2A4A)),
                    ),
                    child: const Text('Step 2 of 3',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  value: 2 / 3,
                  backgroundColor: Color(0xFF2A2A4A),
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Tell us about\nyour body 📐',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.15),
              ),
              const SizedBox(height: 8),
              const Text(
                'This helps us tailor fit recommendations. Totally optional!',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 20),

              // ── Mode toggle ────────────────────────────────
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ModeTab(
                        label: 'Body Type',
                        icon: Icons.accessibility_new_rounded,
                        isActive: _mode == _InputMode.bodyType,
                        onTap: () => _switchMode(_InputMode.bodyType),
                      ),
                    ),
                    Expanded(
                      child: _ModeTab(
                        label: 'Measurements',
                        icon: Icons.straighten_rounded,
                        isActive: _mode == _InputMode.measurements,
                        onTap: () => _switchMode(_InputMode.measurements),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Content ───────────────────────────────────
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _mode == _InputMode.bodyType
                        ? _buildBodyTypeList(bodyTypes)
                        : _buildMeasurementsForm(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── CTA buttons ───────────────────────────────
              AppButton(
                label: 'Continue',
                isLoading: _isLoading,
                isEnabled: _canContinue,
                onTap: () => _saveAndContinue(skip: false),
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : () => _saveAndContinue(skip: true),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    child: Text(
                      'Skip this step',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Body type list ─────────────────────────────────────────────────────

  Widget _buildBodyTypeList(List<BodyTypeOption> bodyTypes) {
    return ListView.separated(
      itemCount: bodyTypes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final opt = bodyTypes[i];
        final isSelected = _selectedBodyType == opt.id;
        return _BodyTypeCard(
          option: opt,
          isSelected: isSelected,
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _selectedBodyType = isSelected ? null : opt.id);
          },
        );
      },
    );
  }

  // ── Measurements form ──────────────────────────────────────────────────

  Widget _buildMeasurementsForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unit toggle
          Row(
            children: [
              const Text('Units:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(width: 10),
              _UnitChip(label: 'cm', isActive: _unit == 'cm', onTap: () => setState(() => _unit = 'cm')),
              const SizedBox(width: 8),
              _UnitChip(label: 'in', isActive: _unit == 'in', onTap: () => setState(() => _unit = 'in')),
            ],
          ),
          const SizedBox(height: 18),

          AppTextField(
            controller: _heightController,
            label: 'Height ($_unit)',
            hint: _unit == 'cm' ? 'e.g. 165' : 'e.g. 65',
            prefixIcon: Icons.height_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),

          AppTextField(
            controller: _bustController,
            label: 'Bust / Chest ($_unit)',
            hint: _unit == 'cm' ? 'e.g. 90' : 'e.g. 35',
            prefixIcon: Icons.straighten_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),

          AppTextField(
            controller: _waistController,
            label: 'Waist ($_unit)',
            hint: _unit == 'cm' ? 'e.g. 70' : 'e.g. 28',
            prefixIcon: Icons.straighten_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),

          AppTextField(
            controller: _hipsController,
            label: 'Hips ($_unit)',
            hint: _unit == 'cm' ? 'e.g. 95' : 'e.g. 37',
            prefixIcon: Icons.straighten_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            helperText: 'Fill in only what you know — all fields are optional',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ── Mode toggle tab ───────────────────────────────────────────────────────

class _ModeTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeTab({required this.label, required this.icon, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? Colors.white : AppColors.textMuted, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textMuted,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Unit chip ─────────────────────────────────────────────────────────────

class _UnitChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _UnitChip({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive ? AppColors.primary : const Color(0xFF2A2A4A)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Body type card ────────────────────────────────────────────────────────

class _BodyTypeCard extends StatelessWidget {
  final BodyTypeOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _BodyTypeCard({required this.option, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFF2A2A4A),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.2) : const Color(0xFF2A2A4A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(option.emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.white,
                      fontSize: 15, fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(option.description,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  if (isSelected) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '💡 ${option.stylingTip}',
                        style: const TextStyle(color: AppColors.primary, fontSize: 11, height: 1.4),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
