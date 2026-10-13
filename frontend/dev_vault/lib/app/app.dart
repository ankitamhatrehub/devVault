import 'package:flutter/material.dart';

import '../core/config/app_router.dart';
import '../core/theme/app_theme.dart';

class DevVaultApp extends StatelessWidget {
  const DevVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.variantNotifier,
      builder: (context, variant, _) {
        return MaterialApp.router(
          title: 'DevVault',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.build(variant, Brightness.light),
          darkTheme: AppTheme.build(variant, Brightness.dark),
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
          builder: (context, child) {
            AppTheme.currentBrightness =
                MediaQuery.platformBrightnessOf(context);
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}
