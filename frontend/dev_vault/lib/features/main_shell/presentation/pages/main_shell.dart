import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_theme.dart';
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: NavigationBar(
            height: 70,
            selectedIndex: _currentIndex,
            indicatorColor: AppColors.primarySoft,
            backgroundColor: Theme.of(context).cardColor,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
              context.go(_tabs[index].route);
            },
            destinations: _tabs
                .map(
                  (tab) => NavigationDestination(
                    icon: Icon(tab.icon),
                    label: tab.label,
                  ),
                )
                .toList(),
          ),
        ),
      ),
      )
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
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Exit')),
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
