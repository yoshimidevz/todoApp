import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel  = 'Cancelar',
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    required VoidCallback onConfirm,
    String confirmLabel = 'Confirmar',
    String cancelLabel  = 'Cancelar',
  }) {
    return showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: title,
        content: content,
        onConfirm: onConfirm,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.heading),
            const SizedBox(height: 16),
            content,
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    cancelLabel,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(context);
                  },
                  child: Text(confirmLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}