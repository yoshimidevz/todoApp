import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/patterns/cards/app_category_chip.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/todo_entity.dart';
import '../cubit/todo_cubit.dart';

class TodoDetailPage extends StatefulWidget {
  final TodoEntity todo;

  const TodoDetailPage({super.key, required this.todo});

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  late bool _isToday;

  @override
  void initState() {
    super.initState();
    _isToday = widget.todo.isToday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalhes da tarefa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.todo),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.todo.title,
              style: AppTextStyles.heading.copyWith(
                decoration: widget.todo.isDone
                    ? TextDecoration.lineThrough
                    : null,
                color: widget.todo.isDone
                    ? AppColors.textDisabled
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            AppCategoryChip(label: widget.todo.category),
            const SizedBox(height: 24),

            _DetailRow(
              icon: Icons.calendar_today,
              label: 'Vencimento',
              value: widget.todo.dueDate ?? 'Sem data',
            ),
            _DetailRow(
              icon: Icons.check_circle_outline,
              label: 'Status',
              value: widget.todo.isDone ? 'Concluída' : 'Pendente',
              valueColor: widget.todo.isDone
                  ? AppColors.success
                  : AppColors.textSecondary,
            ),
            _DetailRow(
              icon: Icons.star_border,
              label: 'Favorita',
              value: widget.todo.isFavorite ? 'Sim' : 'Não',
              valueColor: widget.todo.isFavorite
                  ? AppColors.star
                  : AppColors.textSecondary,
            ),
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_sunny_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text('Para fazer hoje', style: AppTextStyles.body),
                  ],
                ),
                Switch(
                  value: _isToday,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() => _isToday = value);
                    context.read<TodoCubit>().toggleToday(widget.todo.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.body),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}