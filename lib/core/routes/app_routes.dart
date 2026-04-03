import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/todo/domain/entities/todo_entity.dart';
import '../../features/todo/presentation/cubit/todo_cubit.dart';
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
        return TodoDetailPage(todo: todo); 
      },
    ),
  ],
);