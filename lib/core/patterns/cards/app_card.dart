import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'app_category_chip.dart';

class AppCard extends StatelessWidget {
  final String title;
  final String category;
  final String? dueDate;
  final bool isDone;
  final bool isFavorite;
  final VoidCallback onToggleDone;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const AppCard({
    super.key,
    required this.title,
    required this.category,
    required this.isDone,
    required this.isFavorite,
    required this.onToggleDone,
    required this.onToggleFavorite,
    required this.onTap,
    this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: isDone,
          onChanged: (_) => onToggleDone(),
        ),
        title: Text(
          title,
          style: AppTextStyles.body.copyWith(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? AppColors.textDisabled : AppColors.textPrimary,
          ),
        ),
        subtitle: Row(
          children: [
            AppCategoryChip(label: category),
            if (dueDate != null && dueDate!.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(dueDate!, style: AppTextStyles.caption),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? AppColors.star : AppColors.textSecondary,
                size: 20,
              ),
              onPressed: onToggleFavorite,
            ),
            IconButton(
              icon: const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}