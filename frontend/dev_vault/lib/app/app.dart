import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/config/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/settings/data/settings_repository.dart';
import '../features/settings/presentation/cubit/theme_cubit.dart';
import '../features/settings/presentation/cubit/theme_state.dart';

class DevVaultApp extends StatelessWidget {
  const DevVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(SharedPreferencesSettingsRepository())
            ..loadThemeMode(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) => ValueListenableBuilder(
          valueListenable: AppTheme.variantNotifier,
          builder: (context, variant, _) {
            return MaterialApp.router(
              title: 'DevVault',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.build(variant, Brightness.light),
              darkTheme: AppTheme.build(variant, Brightness.dark),
              themeMode: themeState.themeMode,
              themeAnimationDuration: MediaQuery.maybeOf(context)
                      ?.disableAnimations ==
                  true
                  ? Duration.zero
                  : const Duration(milliseconds: 250),
              themeAnimationCurve: Curves.easeInOutCubic,
              routerConfig: AppRouter.router,
              builder: (context, child) {
                AppTheme.currentBrightness = switch (themeState.themeMode) {
                  ThemeMode.system =>
                    MediaQuery.platformBrightnessOf(context),
                  ThemeMode.light => Brightness.light,
                  ThemeMode.dark => Brightness.dark,
                };
                return child ?? const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
