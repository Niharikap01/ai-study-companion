import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 10));

    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(
            begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
            begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
            begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
            begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
    ]).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(
            begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
            begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
            begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: AlignmentTween(
            begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                AppTheme.backgroundDark,
                AppTheme.deepPurple,
                AppTheme.backgroundDark,
              ],
              begin: _topAlignmentAnimation.value,
              end: _bottomAlignmentAnimation.value,
            ),
          ),
          child: Stack(
            children: [
              // Optionally add floating particles here manually or with a package
              Positioned.fill(child: widget.child),
            ],
          ),
        );
      },
    );
  }
}
