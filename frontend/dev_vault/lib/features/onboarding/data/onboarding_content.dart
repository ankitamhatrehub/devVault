import 'package:flutter/material.dart';

class OnboardingPageModel {
  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
}

final onboardingPages = <OnboardingPageModel>[
  const OnboardingPageModel(
    title: 'Track your engineering journey',
    description:
        'Collect milestones, projects, and lessons in one focused workspace built for developers.',
    icon: Icons.rocket_launch_rounded,
    accentColor: Color(0xFF2563EB),
  ),
  const OnboardingPageModel(
    title: 'Prepare for the next role',
    description:
        'Keep interview prep, learning roadmaps, and job applications aligned with your career goals.',
    icon: Icons.psychology_alt_rounded,
    accentColor: Color(0xFF14B8A6),
  ),
  const OnboardingPageModel(
    title: 'Build momentum every day',
    description:
        'Turn notes, goals, and resources into a calm, sustainable habit that grows with you.',
    icon: Icons.auto_awesome_rounded,
    accentColor: Color(0xFFF59E0B),
  ),
];
