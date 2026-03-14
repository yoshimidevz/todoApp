import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/messages/app_messages.dart';
import '../../../../../core/routes/app_routes.dart';
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
              child: ListTile(
                title: Text(todo.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(todo.category),
                    if (todo.dueDate != null && todo.dueDate!.isNotEmpty)
                      Text('Vence em ${todo.dueDate}'),
                  ],
                ),
                leading: Checkbox(
                  value: todo.isDone,
                  onChanged: (_) => context.read<TodoCubit>().toggle(todo.id),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        todo.isFavorite ? Icons.star : Icons.star_border,
                        color: todo.isFavorite ? Colors.amber : null,
                      ),
                      onPressed: () =>
                          context.read<TodoCubit>().toggleFavorite(todo.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () => context.go(
                        AppRoutes.todoDetail,
                        extra: {'todo': todo, 'cubit': context.read<TodoCubit>()},
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}