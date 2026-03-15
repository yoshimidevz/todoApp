import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/messages/app_messages.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/patterns/cards/app_card.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';

class TodoList extends StatelessWidget {
  final bool filterToday;
  const TodoList({super.key, required this.filterToday});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        final todos = filterToday
            ? state.filteredTodos.where((t) => t.isToday).toList()
            : state.filteredTodos;

        if (todos.isEmpty) {
          return const Center(child: Text(AppMessages.emptyList));
        }

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, i) {
            final todo = todos[i];
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
                onToggleDone: () => context.read<TodoCubit>().toggle(todo.id),
                onToggleFavorite: () =>
                    context.read<TodoCubit>().toggleFavorite(todo.id),
                onTap: () => context.go(
                  AppRoutes.todoDetail,
                  extra: {'todo': todo, 'cubit': context.read<TodoCubit>()},
                ),
              ),
            );
          },
        );
      },
    );
  }
}