import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/patterns/cards/app_category_chip.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/messages/app_messages.dart';
import '../../domain/entities/todo_entity.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';
import '../widgets/todo_notes.dart';

class TodoDetailPage extends StatefulWidget {
  final TodoEntity todo;

  const TodoDetailPage({super.key, required this.todo});

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  late bool _isToday;
  late RepeatInterval _repeat;

  @override
  void initState() {
    super.initState();
    _isToday = widget.todo.isToday;
    _repeat  = widget.todo.repeat;
  }

  String _repeatLabel(RepeatInterval repeat) {
    switch (repeat) {
      case RepeatInterval.daily:   return AppMessages.repeatDaily;
      case RepeatInterval.weekly:  return AppMessages.repeatWeekly;
      case RepeatInterval.monthly: return AppMessages.repeatMonthly;
      case RepeatInterval.none:    return AppMessages.repeatNone;
    }
  }

  Future<void> _pickReminder(BuildContext ctx, TodoEntity todo) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: ctx,
      initialDate: todo.reminderAt ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: ctx,
      initialTime: TimeOfDay.fromDateTime(todo.reminderAt ?? now),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time == null || !mounted) return;

    final reminderAt = DateTime(
      date.year, date.month, date.day,
      time.hour, time.minute,
    );

    if (reminderAt.isBefore(now)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha um horário que ainda não passou')),
      );
      return;
    }

    if (!mounted) return;
    context.read<TodoCubit>().setReminder(todo.id, reminderAt);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (ctx, state) {
        final todo = state.todos.firstWhere(
          (t) => t.id == widget.todo.id,
          orElse: () => widget.todo,
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Detalhes da tarefa'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go(AppRoutes.todo),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: AppTextStyles.heading.copyWith(
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                    color: todo.isDone ? AppColors.textDisabled : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                AppCategoryChip(label: todo.category),
                const SizedBox(height: 24),
                _DetailRow(
                  icon: Icons.calendar_today,
                  label: 'Vencimento',
                  value: todo.dueDate ?? 'Sem data',
                ),
                _DetailRow(
                  icon: Icons.check_circle_outline,
                  label: 'Status',
                  value: todo.isDone ? 'Concluída' : 'Pendente',
                  valueColor: todo.isDone ? AppColors.success : AppColors.textSecondary,
                ),
                _DetailRow(
                  icon: Icons.star_border,
                  label: 'Favorita',
                  value: todo.isFavorite ? 'Sim' : 'Não',
                  valueColor: todo.isFavorite ? AppColors.star : AppColors.textSecondary,
                ),
                _DetailRow(
                  icon: Icons.repeat,
                  label: 'Repetição',
                  value: _repeatLabel(_repeat),
                ),
                const Divider(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny_outlined, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text('Para fazer hoje', style: AppTextStyles.body),
                      ],
                    ),
                    Switch(
                      value: _isToday,
                      activeThumbColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() => _isToday = value);
                        context.read<TodoCubit>().toggleToday(todo.id);
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.repeat, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text('Repetir', style: AppTextStyles.body),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: DropdownButton<RepeatInterval>(
                          value: _repeat,
                          underline: const SizedBox(),
                          isExpanded: false,
                          style: AppTextStyles.body.copyWith(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8),
                          items: [
                            DropdownMenuItem(
                              value: RepeatInterval.none,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(AppMessages.repeatNone),
                              ),
                            ),
                            DropdownMenuItem(
                              value: RepeatInterval.daily,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(AppMessages.repeatDaily),
                              ),
                            ),
                            DropdownMenuItem(
                              value: RepeatInterval.weekly,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(AppMessages.repeatWeekly),
                              ),
                            ),
                            DropdownMenuItem(
                              value: RepeatInterval.monthly,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(AppMessages.repeatMonthly),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _repeat = value);
                            context.read<TodoCubit>().setRepeat(todo.id, value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications_outlined, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text('Lembrete', style: AppTextStyles.body),
                      ],
                    ),
                    TextButton(
                      onPressed: () => _pickReminder(ctx, todo),
                      child: Text(
                        todo.reminderAt != null
                            ? '${todo.reminderAt!.day.toString().padLeft(2, '0')}/${todo.reminderAt!.month.toString().padLeft(2, '0')} ${todo.reminderAt!.hour.toString().padLeft(2, '0')}:${todo.reminderAt!.minute.toString().padLeft(2, '0')}'
                            : 'Definir',
                        style: AppTextStyles.body.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 40),
                TodoNotes(todoId: todo.id),
              ],
            ),
          ),
        );
      },
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