import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool? _animationsDisabled;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animationsDisabled = MediaQuery.of(context).disableAnimations;
    if (_animationsDisabled == animationsDisabled) return;

    _animationsDisabled = animationsDisabled;
    if (animationsDisabled) {
      _controller.stop();
      _controller.value = 0.5;
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildDot(double interval) {
    final primary = Theme.of(context).colorScheme.primary;

    if (_animationsDisabled == true) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: CircleAvatar(radius: 3, backgroundColor: primary),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final value = (_controller.value + interval) % 1;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Opacity(
            opacity: value,
            child: CircleAvatar(radius: 3, backgroundColor: primary),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: colorScheme.secondaryContainer,
            child: Icon(
              Icons.smart_toy,
              color: colorScheme.onSecondaryContainer,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(children: [buildDot(0), buildDot(.3), buildDot(.6)]),
          ),
        ],
      ),
    );
  }
}
