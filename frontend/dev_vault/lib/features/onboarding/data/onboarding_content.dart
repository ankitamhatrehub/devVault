class OnboardingPageModel {
  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.imageDescription,
  });

  final String title;
  final String description;
  final String imagePath;
  final String imageDescription;
}

final onboardingPages = <OnboardingPageModel>[
  const OnboardingPageModel(
    title: 'Track your engineering journey',
    description:
        'Collect milestones, projects, and lessons in one focused workspace built for developers.',
    imagePath: 'assets/onboarding/developer-workspace.jpg',
    imageDescription: 'A laptop and plant on a developer workspace desk',
  ),
  const OnboardingPageModel(
    title: 'Prepare for the next role',
    description:
        'Keep interview prep, learning roadmaps, and job applications aligned with your career goals.',
    imagePath: 'assets/onboarding/multi-monitor-workspace.jpg',
    imageDescription: 'A developer working at a desk with multiple monitors',
  ),
  const OnboardingPageModel(
    title: 'Build momentum every day',
    description:
        'Turn notes, goals, and resources into a calm, sustainable habit that grows with you.',
    imagePath: 'assets/onboarding/coding-desk.jpg',
    imageDescription: 'A laptop displaying code on a busy desk',
  ),
];
