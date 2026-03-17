import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/galaxy_background.dart';
import '../widgets/flashcard_orbit_widget.dart';

class FlashcardGalaxyScreen extends StatefulWidget {
  const FlashcardGalaxyScreen({super.key});

  @override
  State<FlashcardGalaxyScreen> createState() => _FlashcardGalaxyScreenState();
}

class _FlashcardGalaxyScreenState extends State<FlashcardGalaxyScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _planetPulseController;
  late AnimationController _ringRotationController;

  static const List<Map<String, String>> _flashcards = [
    {
      'term': 'Photosynthesis', 
      'definition': 'Plants convert sunlight into chemical energy.',
      'image': 'assets/images/biology_flashcard.jpg'
    },
    {
      'term': 'Atom', 
      'definition': 'Basic unit of matter with protons, neutrons, electrons.',
      'image': 'assets/images/chemistry_flashcard.jpg'
    },
    {
      'term': 'Mathematics', 
      'definition': 'Study of numbers, quantity and patterns.',
      'image': 'assets/images/math_flashcard.jpg'
    },
    {
      'term': 'Physics', 
      'definition': 'Science of matter, motion, and energy.',
      'image': 'assets/images/physics_flashcard.jpg'
    },
    {
      'term': 'Chemistry', 
      'definition': 'Study of substances and chemical reactions.',
      'image': 'assets/images/chemistry_flashcard.jpg'
    },
    {
      'term': 'Biology', 
      'definition': 'Study of living organisms.',
      'image': 'assets/images/biology_flashcard.jpg'
    },
  ];

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 38),
    )..repeat();

    _planetPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _ringRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 45),
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _planetPulseController.dispose();
    _ringRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GalaxyBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Flashcard Galaxy'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final centerX = constraints.maxWidth / 2;
              final centerY = constraints.maxHeight / 2;
              final radius = math.min(centerX, centerY) * 0.68;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedBuilder(
                    animation: _ringRotationController,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _OrbitRingsPainter(
                          center: Offset(centerX, centerY),
                          radius: radius,
                          time: _ringRotationController.value,
                        ),
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _orbitController,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _NeonTrailsPainter(
                          center: Offset(centerX, centerY),
                          radius: radius,
                          orbitValue: _orbitController.value,
                          count: _flashcards.length,
                        ),
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _planetPulseController,
                    builder: (context, _) {
                      final pulse = 0.92 + 0.08 * _planetPulseController.value;
                      return Positioned(
                        left: centerX - 90,
                        top: centerY - 90,
                        child: Transform.scale(
                          scale: pulse,
                          child: const _CenterPlanet(),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _orbitController,
                    builder: (context, _) {
                      return Stack(
                        children: List.generate(_flashcards.length, (i) {
                          final angle = (_orbitController.value * 2 * math.pi) +
                              (i * (2 * math.pi / _flashcards.length));
                          const cardW = 200.0;
                          const cardH = 260.0;
                          final x = centerX + radius * math.cos(angle) - cardW / 2;
                          final y = centerY + radius * math.sin(angle) - cardH / 2;

                          return Positioned(
                            left: x,
                            top: y,
                            child: FlashcardOrbitWidget(
                              term: _flashcards[i]['term']!,
                              definition: _flashcards[i]['definition']!,
                              imagePath: _flashcards[i]['image']!,
                              width: cardW,
                              height: cardH,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CenterPlanet extends StatelessWidget {
  const _CenterPlanet();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFF00E5FF).withOpacity(0.9),
              const Color(0xFF0288D1).withOpacity(0.7),
              const Color(0xFF7C4DFF).withOpacity(0.5),
              const Color(0xFF1a0a2e).withOpacity(0.6),
            ],
            stops: const [0.0, 0.4, 0.7, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00E5FF).withOpacity(0.6),
              blurRadius: 50,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: const Color(0xFF7C4DFF).withOpacity(0.3),
              blurRadius: 80,
            ),
          ],
        ),
          child: const Center(
            child: Text(
              'Topics',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ),
    );
  }
}

class _OrbitRingsPainter extends CustomPainter {
  final Offset center;
  final double radius;
  final double time;

  _OrbitRingsPainter({
    required this.center,
    required this.radius,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const neonCyan = Color(0xFF00E5FF);

    for (int ring = 0; ring < 3; ring++) {
      final r = radius + (ring * 12.0);
      final rotation = time * 2 * math.pi + (ring * 0.4);

      final path = Path();
      for (int i = 0; i <= 72; i++) {
        final a = (i / 72) * 2 * math.pi + rotation;
        final x = center.dx + r * math.cos(a);
        final y = center.dy + r * math.sin(a);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();

      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..shader = null,
      );

      final glow = Paint()
        ..color = neonCyan.withOpacity(0.15 - ring * 0.03)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawPath(
        path,
        glow,
      );

      final stroke = Paint()
        ..color = neonCyan.withOpacity(0.5 - ring * 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitRingsPainter old) {
    return old.center != center || old.radius != radius || old.time != time;
  }
}

class _NeonTrailsPainter extends CustomPainter {
  final Offset center;
  final double radius;
  final double orbitValue;
  final int count;

  _NeonTrailsPainter({
    required this.center,
    required this.radius,
    required this.orbitValue,
    required this.count,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const trailColor = Color(0xFF00E5FF);

    for (int i = 0; i < count; i++) {
      final baseAngle = (orbitValue * 2 * math.pi) + (i * (2 * math.pi / count));

      for (int t = 1; t <= 5; t++) {
        final angle = baseAngle - (t * 0.08);
        final r = radius - (t * 3);
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);
        final opacity = (0.12 - t * 0.02).clamp(0.02, 0.12);

        canvas.drawCircle(
          Offset(x, y),
          20.0,
          Paint()
            ..color = trailColor.withOpacity(opacity)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NeonTrailsPainter old) {
    return old.center != center ||
        old.radius != radius ||
        old.orbitValue != orbitValue ||
        old.count != count;
  }
}
