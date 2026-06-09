import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isEnabled;
  final Color? color;
  final bool isOutlined;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.isEnabled = true,
    this.color,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isEnabled ? 1.0 : 0.5,
        child: isOutlined
            ? OutlinedButton(
          onPressed: isEnabled && !isLoading ? _handleTap : null,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: effectiveColor, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            foregroundColor: effectiveColor,
          ),
          child: _buildChild(),
        )
            : ElevatedButton(
          onPressed: isEnabled && !isLoading ? _handleTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: _buildChild(),
        ),
      ),
    );
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    onTap?.call();
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    return Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}
