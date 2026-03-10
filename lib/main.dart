import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/todo/presentation/pages/todo_page.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection.dart';
import 'core/routes/app_routes.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}