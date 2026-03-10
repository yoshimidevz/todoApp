import 'package:flutter/material.dart';
import 'features/todo/presentation/pages/todo_page.dart';
import 'core/theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      home: const TodoPage(),
    );
  }
}