import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ComingSoonBadge extends StatelessWidget {
  final Widget child;
  final String label;
  final bool disabled;

  const ComingSoonBadge({
    required this.child,
    this.label = 'Coming Soon',
    this.disabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          duration: MediaQuery.of(context).disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 180),
          opacity: disabled ? 0.5 : 1,
          child: disabled ? IgnorePointer(child: child) : child,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: MediaQuery.of(context).disableAnimations ? 1 : 0.88,
              end: 1,
            ),
            duration: MediaQuery.of(context).disableAnimations
                ? Duration.zero
                : const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
