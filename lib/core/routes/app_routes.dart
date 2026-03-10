import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';                                    // ← BlocProvider
import 'package:go_router/go_router.dart';
import '../../features/todo/domain/entities/todo_entity.dart';
import '../../features/todo/presentation/cubit/todo_cubit.dart';                   // ← TodoCubit
import '../../features/todo/presentation/pages/todo_detail_page.dart';
import '../../features/todo/presentation/pages/todo_page.dart';
abstract class AppRoutes {
  static const String todo       = '/';
  static const String todoDetail = '/todo-detail';
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
        final extra = state.extra as Map<String, dynamic>;
        final todo  = extra['todo'] as TodoEntity;
        final cubit = extra['cubit'] as TodoCubit;
        return BlocProvider.value(
          value: cubit,
          child: TodoDetailPage(todo: todo),
        );
      },
    ),
  ],
);