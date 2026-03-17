// lib/widgets/galaxy_background.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class GalaxyBackground extends StatefulWidget {
  const GalaxyBackground({super.key});

  @override
  State<GalaxyBackground> createState() => _GalaxyBackgroundState();
}

class _GalaxyBackgroundState extends State<GalaxyBackground>
    with TickerProviderStateMixin {
  late final AnimationController _starController;
  late final AnimationController _parallaxController;
  late final List<_StarData> _stars;
  static const int _starCount = 160;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _parallaxController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    final random = math.Random(11);
    _stars = List.generate(_starCount, (_) {
      return _StarData(
        dx: random.nextDouble(),
        dy: random.nextDouble(),
        radius: 0.5 + random.nextDouble() * 1.8,
        baseOpacity: 0.2 + random.nextDouble() * 0.15,
        phase: random.nextDouble() * 2 * math.pi,
      );
    });
  }

  @override
  void dispose() {
    _starController.dispose();
    _parallaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge([_starController, _parallaxController]),
        builder: (context, _) {
          final t = _starController.value;
          final parallaxT = _parallaxController.value;
          final parallaxX = 0.02 * math.sin(parallaxT * 2 * math.pi);
          final parallaxY = 0.02 * math.cos(parallaxT * 2 * math.pi * 0.7);

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1a0a2e),
                  Color(0xFF140B33),
                  Color(0xFF001B4D),
                  Color(0xFF0a0a12),
                  Colors.black,
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Layer1Gradient(parallaxX: parallaxX, parallaxY: parallaxY),
                CustomPaint(
                  painter: _GalaxyStarPainter(
                    stars: _stars,
                    time: t,
                  ),
                  size: Size.infinite,
                ),
                _FloatingStudyIcons(time: t),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Layer1Gradient extends StatelessWidget {
  final double parallaxX;
  final double parallaxY;

  const Layer1Gradient({
    super.key,
    required this.parallaxX,
    required this.parallaxY,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(parallaxX * 30, parallaxY * 30),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.3 + parallaxX, 0.2 + parallaxY),
            radius: 1.2,
            colors: [
              const Color(0xFF2d1b4e).withOpacity(0.4),
              const Color(0xFF1a0a2e).withOpacity(0.2),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _StarData {
  final double dx;
  final double dy;
  final double radius;
  final double baseOpacity;
  final double phase;

  const _StarData({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.baseOpacity,
    required this.phase,
  });
}

class _GalaxyStarPainter extends CustomPainter {
  final List<_StarData> stars;
  final double time;

  _GalaxyStarPainter({required this.stars, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final star in stars) {
      final x = star.dx * size.width;
      final y = star.dy * size.height;
      final twinkle = 0.5 + 0.5 * math.sin(time * 2 * math.pi + star.phase);
      final opacity = (star.baseOpacity * twinkle).clamp(0.2, 0.35);
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), star.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GalaxyStarPainter oldDelegate) {
    return oldDelegate.time != time;
  }
}

class _FloatingStudyIcons extends StatelessWidget {
  final double time;

  const _FloatingStudyIcons({required this.time});

  static const List<_IconConfig> _configs = [
    _IconConfig(icon: Icons.menu_book, baseX: 0.12, baseY: 0.78),
    _IconConfig(icon: Icons.biotech, baseX: 0.82, baseY: 0.72),
    _IconConfig(icon: Icons.hub, baseX: 0.18, baseY: 0.32),
    _IconConfig(icon: Icons.calculate, baseX: 0.88, baseY: 0.38),
    _IconConfig(icon: Icons.psychology, baseX: 0.32, baseY: 0.16),
    _IconConfig(icon: Icons.school, baseX: 0.68, baseY: 0.18),
    _IconConfig(icon: Icons.note, baseX: 0.06, baseY: 0.52),
    _IconConfig(icon: Icons.edit, baseX: 0.94, baseY: 0.56),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return IgnorePointer(
      ignoring: true,
      child: Stack(
        children: List.generate(_configs.length, (index) {
          final cfg = _configs[index];
          final phase = (index / _configs.length) * 2 * math.pi;
          final float = math.sin(time * 2 * math.pi + phase);
          final drift = math.cos(time * 2 * math.pi * 0.5 + phase);
          final fade = 0.5 +
              0.5 * math.sin(time * 2 * math.pi * 0.3 + phase * 1.5);

          final dx = cfg.baseX * size.width + drift * 24;
          final dy = cfg.baseY * size.height + float * -48;

          final opacityBase = (0.2 + 0.15 * fade).clamp(0.2, 0.35);
          final rotation = 0.15 * math.sin(time * 2 * math.pi * 0.7 + phase);

          return Positioned(
            left: dx,
            top: dy,
            child: Opacity(
              opacity: opacityBase,
              child: Transform.rotate(
                angle: rotation,
                child: Icon(
                  cfg.icon,
                  size: 42,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _IconConfig {
  final IconData icon;
  final double baseX;
  final double baseY;

  const _IconConfig({
    required this.icon,
    required this.baseX,
    required this.baseY,
  });
}