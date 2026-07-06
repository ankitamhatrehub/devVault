import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dev_vault/features/authentication/presentation/pages/login_screen.dart';
import 'package:dev_vault/features/learning/presentation/pages/learning_roadmap_screen.dart';
import 'package:dev_vault/features/learning/presentation/pages/resources_screen.dart';
import 'package:dev_vault/main.dart';

void main() {
  testWidgets('shows the DevVault splash experience', (tester) async {
    await tester.pumpWidget(const DevVaultApp());

    expect(find.text('DevVault'), findsOneWidget);
    expect(find.text('One Place. Every Developer\'s Journey.'), findsOneWidget);
  });

  testWidgets('renders the login screen content', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Continue to DevVault'), findsOneWidget);
  });

  testWidgets('renders the learning roadmap screen content', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LearningRoadmapScreen()));

    expect(find.text('Learning roadmap'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
  });

  testWidgets('renders the learning resources screen content', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ResourcesScreen()));

    expect(find.text('Resources library'), findsOneWidget);
    expect(find.text('Flutter docs'), findsOneWidget);
  });
}
