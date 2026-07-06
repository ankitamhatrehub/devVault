import 'package:flutter/material.dart';

import '../core/config/app_router.dart';
import '../core/theme/app_theme.dart';

class DevVaultApp extends StatelessWidget {
  const DevVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DevVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
