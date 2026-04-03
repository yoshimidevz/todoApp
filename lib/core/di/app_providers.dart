import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_2/core/di/injection.dart';
import '../../features/todo/presentation/cubit/category_cubit.dart';
import '../../features/todo/presentation/cubit/todo_cubit.dart';
class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<TodoCubit>()),
        BlocProvider(create: (_) => getIt<CategoryCubit>()),
      ],
      child: child,
    );
  }
}