import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../ai_chats/ai_chat_screen.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../../learning/presentation/pages/learning_roadmap_screen.dart';
import '../../../notes/presentation/pages/notes_screen.dart';
import '../../../projects/presentation/pages/projects_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<_ShellTab> _tabs = const [
    _ShellTab(label: 'Home', icon: Icons.home_rounded, route: Routes.dashboard),
    _ShellTab(
      label: 'Projects',
      icon: Icons.folder_open_rounded,
      route: Routes.projects,
    ),
    _ShellTab(
      label: 'Learn',
      icon: Icons.auto_awesome_rounded,
      route: Routes.learning,
    ),
    _ShellTab(
      label: 'Notes',
      icon: Icons.note_alt_outlined,
      route: Routes.notes,
    ),
    _ShellTab(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      route: Routes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          context.go(Routes.dashboard);
          return;
        }
        final shouldExit = await _showExitDialog(context);
        if (shouldExit) SystemNavigator.pop();
      },
      child: Scaffold(
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton.extended(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                icon: Icon(
                  Icons.smart_toy,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  'AI Chat',
                  style:
                      Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ) ??
                      TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AiChatScreen()),
                  );
                },
              )
            : null,
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            DashboardScreen(),
            ProjectsScreen(),
            LearningRoadmapScreen(),
            NotesScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: GlassSurface(
            padding: EdgeInsets.zero,
            borderRadius: AppRadius.large,
            child: NavigationBar(
              height: 70,
              selectedIndex: _currentIndex,
              indicatorColor: colorScheme.primaryContainer.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.72 : 0.82,
              ),
              indicatorShape: const StadiumBorder(),
              backgroundColor: colorScheme.surface.withValues(alpha: 0),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
                context.go(_tabs[index].route);
              },
              destinations: _tabs
                  .asMap()
                  .entries
                  .map(
                    (entry) => NavigationDestination(
                      icon: _AnimatedNavigationIcon(
                        icon: entry.value.icon,
                        selected: entry.key == _currentIndex,
                        reduceMotion: reduceMotion,
                      ),
                      label: entry.value.label,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedNavigationIcon extends StatelessWidget {
  const _AnimatedNavigationIcon({
    required this.icon,
    required this.selected,
    required this.reduceMotion,
  });

  final IconData icon;
  final bool selected;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedScale(
      scale: selected ? 1.08 : 1,
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.16),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : const [],
        ),
        child: Icon(
          icon,
          color: selected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

Future<bool> _showExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Exit app'),
      content: const Text('Are you sure you want to exit the app?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Exit'),
        ),
      ],
    ),
  );
  return result == true;
}

class _ShellTab {
  const _ShellTab({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}
