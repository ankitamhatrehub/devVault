import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/services/local_storage_service.dart';
import '../../../../data/services/auth_service.dart';
import '../../data/settings_model.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../cubit/theme_cubit.dart';
import '../cubit/theme_state.dart';
import '../widgets/settings_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<SettingsCubit, SettingsState>(
              listenWhen: (previous, current) =>
                  previous.status != SettingsStatus.failure &&
                  current.status == SettingsStatus.failure,
              listener: (context, state) => _showError(
                context,
                state.errorMessage ?? 'Unable to save settings.',
              ),
            ),
            BlocListener<ThemeCubit, ThemeState>(
              listenWhen: (previous, current) =>
                  previous.status != ThemeStatus.failure &&
                  current.status == ThemeStatus.failure,
              listener: (context, state) => _showError(
                context,
                state.errorMessage ?? 'Unable to save appearance settings.',
              ),
            ),
          ],
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              if (state.status == SettingsStatus.initial ||
                  state.status == SettingsStatus.loading) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: AppSkeletonList(itemCount: 4),
                );
              }

              if (state.status == SettingsStatus.failure &&
                  !state.isInitialized) {
                return _SettingsFailure(
                  message: state.errorMessage ?? 'Unable to load settings.',
                  onRetry: context.read<SettingsCubit>().loadSettings,
                );
              }

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  if (state.status == SettingsStatus.failure)
                    _InlineSettingsError(
                      message: state.errorMessage ?? 'Unable to save settings.',
                    ),
                  _AppearanceSection(),
                  const SizedBox(height: AppSpacing.md),
                  _NotificationSection(preferences: state.preferences),
                  const SizedBox(height: AppSpacing.md),
                  _SecuritySection(preferences: state.preferences),
                  const SizedBox(height: AppSpacing.md),
                  _AccountSection(onSignOut: () => _confirmSignOut(context)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => GlassAlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );

    if (shouldSignOut != true || !context.mounted) return;
    await AuthService.logout();
    if (context.mounted) context.go(Routes.login);
  }
}

class _AppearanceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        Text(
          'Choose how DevVault looks on this device.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.status == ThemeStatus.failure) ...[
                Text(
                  state.errorMessage ??
                      'Unable to load or save appearance settings.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: Icon(Icons.settings_suggest_outlined),
                    label: Text('System'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: Icon(Icons.light_mode_outlined),
                    label: Text('Light'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: Icon(Icons.dark_mode_outlined),
                    label: Text('Dark'),
                  ),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (selection) =>
                    context.read<ThemeCubit>().setThemeMode(selection.first),
                showSelectedIcon: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotificationSection extends StatelessWidget {
  const _NotificationSection({required this.preferences});

  final SettingsPreferences preferences;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    return SettingsSection(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        SettingsSwitchTile(
          title: 'Push notifications',
          subtitle: 'Allow app notifications on this device.',
          value: preferences.pushNotificationsEnabled,
          onChanged: cubit.setPushNotificationsEnabled,
        ),
        SettingsSwitchTile(
          title: 'Reminders',
          subtitle: 'Get reminders for tasks and learning goals.',
          value: preferences.reminderNotificationsEnabled,
          onChanged: cubit.setReminderNotificationsEnabled,
        ),
        SettingsSwitchTile(
          title: 'Security alerts',
          subtitle: 'Get notified about important account activity.',
          value: preferences.securityAlertsEnabled,
          onChanged: cubit.setSecurityAlertsEnabled,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            'These preferences are saved locally. Notification delivery will '
            'be connected in a later update.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({required this.preferences});

  final SettingsPreferences preferences;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    return SettingsSection(
      title: 'Security',
      icon: Icons.shield_outlined,
      children: [
        SettingsSwitchTile(
          title: 'App Lock',
          subtitle:
              'Preference only; PIN/biometric enforcement is coming '
              'with the security feature.',
          value: preferences.appLockEnabled,
          onChanged: cubit.setAppLockEnabled,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Change PIN'),
          subtitle: const Text('Available with PIN setup.'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PIN setup will be available in the next feature.'),
            ),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Auto-lock timeout'),
          subtitle: const Text('Choose when the vault should lock.'),
          trailing: DropdownButton<int>(
            value: preferences.autoLockTimeoutSeconds,
            underline: const SizedBox.shrink(),
            items: const [
              DropdownMenuItem(value: 0, child: Text('Immediately')),
              DropdownMenuItem(value: 30, child: Text('30 seconds')),
              DropdownMenuItem(value: 60, child: Text('1 minute')),
              DropdownMenuItem(value: 300, child: Text('5 minutes')),
            ],
            onChanged: (value) {
              if (value != null) cubit.setAutoLockTimeoutSeconds(value);
            },
          ),
        ),
      ],
    );
  }
}

class _AccountSection extends StatefulWidget {
  const _AccountSection({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  State<_AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends State<_AccountSection> {
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    final name = LocalStorageService.getUserName();
    final email = LocalStorageService.getUserEmail();
    return SettingsSection(
      title: 'Account',
      icon: Icons.person_outline_rounded,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.person_outline_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(name?.isNotEmpty == true ? name! : 'DevVault account'),
          subtitle: Text(
            email?.isNotEmpty == true ? email! : 'Account details',
          ),
        ),
        FutureBuilder<PackageInfo>(
          future: _packageInfo,
          builder: (context, snapshot) {
            final versionLabel = snapshot.hasError
                ? 'Version information unavailable'
                : snapshot.hasData
                ? 'Version ${snapshot.data!.version}'
                : 'Loading version…';
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('App version'),
              subtitle: Text(versionLabel),
            );
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.logout_rounded,
            color: Theme.of(context).colorScheme.error,
          ),
          title: const Text('Sign out'),
          onTap: widget.onSignOut,
        ),
      ],
    );
  }
}

class _SettingsFailure extends StatelessWidget {
  const _SettingsFailure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineSettingsError extends StatelessWidget {
  const _InlineSettingsError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.small),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
