import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AppSnackbar {
  static void error(BuildContext context, String message) {
    _show(context, message, AppColors.accent, Icons.error_outline_rounded);
  }

  static void success(BuildContext context, String message) {
    _show(context, message, AppColors.success, Icons.check_circle_outline_rounded);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, AppColors.primary, Icons.info_outline_rounded);
  }

  static void _show(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
