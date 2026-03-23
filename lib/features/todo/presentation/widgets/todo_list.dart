import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/messages/app_messages.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/patterns/cards/app_card.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/todo_entity.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';

class TodoList extends StatelessWidget {
  final bool filterToday;
  final bool filterImportant;

  const TodoList({
    super.key, 
    required this.filterToday, 
    required this.filterImportant,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        var todos = filterToday
            ? state.filteredTodos.where((t) => t.isToday).toList()
            : state.filteredTodos;

        if (filterImportant) {
          todos = todos.where((t) => t.isFavorite).toList();
        }

        final pending   = todos.where((t) => !t.isDone).toList();
        final completed = todos.where((t) => t.isDone).toList();

        if (todos.isEmpty) {
          return const Center(child: Text(AppMessages.emptyList));
        }

        return _TodoListView(pending: pending, completed: completed);
      },
    );
  }
}

class _TodoListView extends StatefulWidget {
  final List<TodoEntity> pending;
  final List<TodoEntity> completed;

  const _TodoListView({required this.pending, required this.completed});

  @override
  State<_TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<_TodoListView> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...widget.pending.map((todo) => _buildDismissible(context, todo)),

        if (widget.completed.isNotEmpty)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Concluídas (${widget.completed.length})',
                    style: AppTextStyles.label,
                  ),
                ],
              ),
            ),
          ),

        if (_expanded)
          ...widget.completed.map((todo) => _buildDismissible(context, todo)),
      ],
    );
  }

  Widget _buildDismissible(BuildContext context, TodoEntity todo) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.4},
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => context.read<TodoCubit>().delete(todo.id),
      child: AppCard(
        title: todo.title,
        category: todo.category,
        dueDate: todo.dueDate,
        isDone: todo.isDone,
        isFavorite: todo.isFavorite,
        repeat: todo.repeat,
        onToggleDone: () => context.read<TodoCubit>().toggle(todo.id),
        onToggleFavorite: () =>
            context.read<TodoCubit>().toggleFavorite(todo.id),
        onTap: () => context.go(
          AppRoutes.todoDetail,
          extra: {'todo': todo, 'cubit': context.read<TodoCubit>()},
        ),
      ),
    );
  }
}