import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Reusable Common Loading Indicator
///
/// Centered progress indicator used across screens and dialogs
/// when awaiting asynchronous operations.
class CommonLoader extends StatelessWidget {
  final Color? color;
  final double size;
  final String? message;

  const CommonLoader({
    super.key,
    this.color,
    this.size = 36.0,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
