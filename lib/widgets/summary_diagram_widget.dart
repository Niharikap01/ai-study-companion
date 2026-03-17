// lib/widgets/summary_diagram_widget.dart
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class SummaryDiagramWidget extends StatefulWidget {
  final String topic;
  final List<String> keyPoints;
  final double height;

  const SummaryDiagramWidget({
    super.key,
    required this.topic,
    required this.keyPoints,
    this.height = 320,
  });

  @override
  State<SummaryDiagramWidget> createState() => _SummaryDiagramWidgetState();
}

class _SummaryDiagramWidgetState extends State<SummaryDiagramWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color electricBlue = Color(0xFF0288D1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> _normalizedPoints() {
    final out = <String>[];
    for (final raw in widget.keyPoints) {
      final s = raw.trim();
      if (s.isEmpty) continue;
      final cleaned = s.replaceAll(RegExp(r'^[•\-\*\d\.\)\s]+'), '').trim();
      if (cleaned.isEmpty) continue;
      if (!out.contains(cleaned)) out.add(cleaned);
      if (out.length >= 7) break;
    }
    return out.isEmpty ? const ['Key Idea', 'Concept', 'Example', 'Process'] : out;
  }

  @override
  Widget build(BuildContext context) {
    final points = _normalizedPoints();

    return RepaintBoundary(
      child: SizedBox(
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                final center = Offset(w / 2, h / 2);

                final baseR = math.min(w, h) * 0.30;
                final ringStep = math.min(w, h) * 0.07;

                final t = _controller.value * 2 * math.pi;
                final nodes = <_OrbitNode>[];
                for (int i = 0; i < points.length; i++) {
                  final ring = (i % 3);
                  final r = baseR + ring * ringStep;
                  final phase = (i / points.length) * 2 * math.pi;
                  final wobble = 10.0 * math.sin(t * 1.4 + phase * 1.7);
                  final angle = t * (0.22 + ring * 0.05) + phase;
                  final pos = center +
                      Offset(
                        (r + wobble) * math.cos(angle),
                        (r + wobble) * math.sin(angle) * 0.85,
                      );
                  nodes.add(_OrbitNode(
                    label: points[i],
                    position: pos,
                    ring: ring,
                  ));
                }

                final centerPulse = 0.5 + 0.5 * math.sin(t * 1.3);

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomPaint(
                      size: Size(w, h),
                      painter: _GalaxyDiagramPainter(
                        center: center,
                        centerPulse: centerPulse,
                        nodes: nodes,
                      ),
                    ),
                    Positioned.fill(
                      child: _CenterNode(
                        center: center,
                        label: widget.topic.trim().isEmpty
                            ? 'Topic'
                            : widget.topic.trim(),
                        pulse: centerPulse,
                      ),
                    ),
                    for (final n in nodes)
                      _OrbitingNode(
                        position: n.position,
                        ring: n.ring,
                        label: n.label,
                        time: _controller.value,
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _OrbitNode {
  final String label;
  final Offset position;
  final int ring;

  const _OrbitNode({
    required this.label,
    required this.position,
    required this.ring,
  });
}

class _GalaxyDiagramPainter extends CustomPainter {
  final Offset center;
  final double centerPulse;
  final List<_OrbitNode> nodes;

  _GalaxyDiagramPainter({
    required this.center,
    required this.centerPulse,
    required this.nodes,
  });

  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color electricBlue = Color(0xFF0288D1);

  @override
  void paint(Canvas canvas, Size size) {
    final bgGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          neonCyan.withOpacity(0.10),
          electricBlue.withOpacity(0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: size.shortestSide * 0.55),
      )
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bgGlow);

    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withOpacity(0.05);

    final ringR = [
      size.shortestSide * 0.30,
      size.shortestSide * 0.37,
      size.shortestSide * 0.44,
    ];
    for (final r in ringR) {
      canvas.drawOval(
        Rect.fromCenter(center: center, width: r * 2, height: r * 2 * 0.85),
        orbitPaint,
      );
    }

    final lineGlow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.6
      ..color = neonCyan.withOpacity(0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1.2
      ..color = neonCyan.withOpacity(0.35);

    for (final n in nodes) {
      canvas.drawLine(center, n.position, lineGlow);
      canvas.drawLine(center, n.position, line);
    }

    final coreGlow = Paint()
      ..style = PaintingStyle.fill
      ..color = neonCyan.withOpacity(0.14 + 0.10 * centerPulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
    canvas.drawCircle(center, 34 + 6 * centerPulse, coreGlow);
  }

  @override
  bool shouldRepaint(covariant _GalaxyDiagramPainter oldDelegate) {
    return oldDelegate.centerPulse != centerPulse || oldDelegate.nodes != nodes;
  }
}

class _CenterNode extends StatelessWidget {
  final Offset center;
  final String label;
  final double pulse;

  const _CenterNode({
    required this.center,
    required this.label,
    required this.pulse,
  });

  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color electricBlue = Color(0xFF0288D1);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: center.dx - 60,
          top: center.dy - 38,
          width: 120,
          child: Transform.translate(
            offset: Offset(0, -2 * math.sin(pulse * math.pi)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: Colors.white.withOpacity(0.08),
                border: Border.all(
                  color: neonCyan.withOpacity(0.55),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: neonCyan.withOpacity(0.22 + 0.12 * pulse),
                    blurRadius: 22,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: electricBlue.withOpacity(0.14),
                    blurRadius: 18,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrbitingNode extends StatelessWidget {
  final Offset position;
  final int ring;
  final String label;
  final double time;

  const _OrbitingNode({
    required this.position,
    required this.ring,
    required this.label,
    required this.time,
  });

  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color electricBlue = Color(0xFF0288D1);

  @override
  Widget build(BuildContext context) {
    final baseSize = 56.0 - ring * 4.0;
    final float = math.sin((time * 2 * math.pi) * 1.8 + ring) * 4.0;
    final shimmer =
        0.5 + 0.5 * math.sin((time * 2 * math.pi) * 1.1 + ring * 1.7);

    return Positioned(
      left: position.dx - baseSize / 2,
      top: position.dy - baseSize / 2 + float,
      width: baseSize,
      height: baseSize,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.06),
          border: Border.all(
            color: neonCyan.withOpacity(0.40 + 0.20 * shimmer),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: neonCyan.withOpacity(0.20 + 0.12 * shimmer),
              blurRadius: 18,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: electricBlue.withOpacity(0.12),
              blurRadius: 14,
            ),
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.92),
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}