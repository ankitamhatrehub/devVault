import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({
    required this.child,
    this.compact = false,
    super.key,
  });

  final Widget child;
  final bool compact;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool? _reduceMotion;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (_reduceMotion == reduceMotion) return;

    _reduceMotion = reduceMotion;
    if (reduceMotion) {
      _controller
        ..stop()
        ..value = 0.5;
    } else {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: colorScheme.surface),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final progress = _controller.value;
              final drift = _reduceMotion == true ? 0.0 : progress * 28 - 14;

              if (widget.compact) {
                return Stack(
                  children: [
                    Positioned(
                      top: -92 + drift * 0.35,
                      right: -88,
                      child: _GradientBlob(
                        color: colorScheme.primary,
                        size: 210,
                      ),
                    ),
                  ],
                );
              }

              return Stack(
                children: [
                  Positioned(
                    top: -120 + drift,
                    right: -110,
                    child: _GradientBlob(color: colorScheme.primary),
                  ),
                  Positioned(
                    bottom: -150 + drift,
                    left: -130,
                    child: _GradientBlob(
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _GradientBlob extends StatelessWidget {
  const _GradientBlob({required this.color, this.size = 340});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 0.18),
                color.withValues(alpha: 0.08),
                color.withValues(alpha: 0),
              ],
              stops: const [0, 0.48, 1],
            ),
          ),
        ),
      ),
    );
  }
}
