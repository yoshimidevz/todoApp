import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/todo/domain/entities/todo_entity.dart';
import '../../features/todo/presentation/pages/todo_detail_page.dart';
import '../../features/todo/presentation/pages/todo_page.dart'; 
abstract class AppRoutes {
  static const String todo       = '/';
  static const String todoDetail = '/todo-detail'; // ← novo
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.todo,
  routes: [
    GoRoute(
      path: AppRoutes.todo,
      builder: (context, state) => const TodoPage(),
    ),
    GoRoute(
      path: AppRoutes.todoDetail,
      builder: (context, state) {
        final todo = state.extra as TodoEntity; // ← recebe a tarefa
        return TodoDetailPage(todo: todo);
      },
    ),
  ],
);