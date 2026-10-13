import 'package:flutter/material.dart';
import '../../../../core/widgets/widgets.dart';

class LearningSkeleton extends StatelessWidget {
  const LearningSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppSkeletonList(
      itemCount: 6,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
