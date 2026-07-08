import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('👤 ProfileScreen initialized');
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      print('📡 Loading user profile...');
      final profile = await ProfileService.getProfile();
      if (!mounted) return;
      print('✅ Profile loaded successfully');
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      print('❌ Error loading profile: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text('Unable to load profile: $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primarySoft,
                          child: const Icon(
                            Icons.person_outline_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile?.name.isNotEmpty == true
                                    ? profile!.name
                                    : 'Your name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                profile?.email.isNotEmpty == true
                                    ? profile!.email
                                    : 'your@email.com',
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final result = await context.push<bool?>(
                              Routes.editProfile,
                              extra: {
                                'id': profile?.id ?? '',
                                'name': profile?.name ?? '',
                                'email': profile?.email ?? '',
                              },
                            );
                            if (result == true) {
                              await _loadProfile();
                            }
                          },
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: 'Edit profile',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _ProfileSection(
                      title: 'Account',
                      children: [
                        ListTile(
                          enabled: false,
                          leading: const Icon(Icons.settings_outlined),
                          title: const Text('Settings'),
                          subtitle: const Text('Coming soon'),
                          onTap: null,
                        ),
                        ListTile(
                          leading: const Icon(Icons.lock_reset_rounded),
                          title: const Text('Change password'),
                          onTap: () => context.go(Routes.changePassword),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _ProfileSection(
                      title: 'Danger zone',
                      children: [
                        ListTile(
                          leading: const Icon(Icons.logout_rounded),
                          title: const Text('Logout'),
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Sign out'),
                                content: const Text(
                                  'Are you sure you want to sign out?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => context.go(Routes.login),
                                    child: const Text('Sign out'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
