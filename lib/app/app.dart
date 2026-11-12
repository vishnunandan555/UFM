import 'package:flutter/material.dart';
import 'package:ufm/app/router.dart';
import 'package:ufm/app/theme/app_theme.dart';

class UfmApp extends StatelessWidget {
  const UfmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UFM',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
