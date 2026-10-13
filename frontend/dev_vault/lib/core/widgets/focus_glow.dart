import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FocusGlow extends StatefulWidget {
  const FocusGlow({required this.child, super.key});

  final Widget child;

  @override
  State<FocusGlow> createState() => _FocusGlowState();
}

class _FocusGlowState extends State<FocusGlow> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Focus(
      onFocusChange: (hasFocus) {
        if (_hasFocus == hasFocus) return;
        setState(() => _hasFocus = hasFocus);
      },
      child: AnimatedContainer(
        duration: MediaQuery.of(context).disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: _hasFocus
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.14),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ]
              : const [],
        ),
        child: widget.child,
      ),
    );
  }
}
