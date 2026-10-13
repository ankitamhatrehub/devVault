import 'package:flutter/material.dart';

class StaggeredColumn extends StatefulWidget {
  const StaggeredColumn({
    required this.children,
    this.spacing = 0,
    super.key,
  });

  final List<Widget> children;
  final double spacing;

  @override
  State<StaggeredColumn> createState() => _StaggeredColumnState();
}

class _StaggeredColumnState extends State<StaggeredColumn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool? _reduceMotion;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (_reduceMotion == reduceMotion) return;

    _reduceMotion = reduceMotion;
    if (reduceMotion) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.children.length;
    final children = <Widget>[];

    for (var index = 0; index < count; index++) {
      if (index > 0 && widget.spacing > 0) {
        children.add(SizedBox(height: widget.spacing));
      }

      final begin = count <= 1 ? 0.0 : (index / count) * 0.58;
      final end = (begin + 0.42).clamp(0.0, 1.0);
      final animation = CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      );

      children.add(
        FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ),
            ),
            child: widget.children[index],
          ),
        ),
      );
    }

    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}
