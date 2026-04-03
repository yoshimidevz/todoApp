import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection.dart';
import 'core/routes/app_routes.dart';
import 'core/di/app_providers.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

// main.dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}