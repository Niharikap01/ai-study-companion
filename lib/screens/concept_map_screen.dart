import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/galaxy_background.dart';

class ConceptMapScreen extends StatefulWidget {
  const ConceptMapScreen({super.key});

  @override
  State<ConceptMapScreen> createState() => _ConceptMapScreenState();
}

class _ConceptMapScreenState extends State<ConceptMapScreen> {
  final TextEditingController _topicController = TextEditingController();
  bool _mapGenerated = false;
  String _topic = '';
  @override
  void dispose() {
    _topicController.dispose();
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Interactive Concept Map',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: _mapGenerated ? _buildMap() : _buildInputUi(),
        ),
      ],
    );
  }

  Widget _buildInputUi() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.neonCyan.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.neonCyan.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.hub_outlined,
                color: AppTheme.neonCyan,
                size: 64,
              ),
              const SizedBox(height: 24),
              const Text(
                'Generate Concept Map',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter a topic to explore its connections in the universe.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _topicController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g., Photosynthesis, Black Holes, AI...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.neonCyan),
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.neonCyan),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_topicController.text.trim().isNotEmpty) {
                      setState(() {
                        _topic = _topicController.text.trim();
                        _mapGenerated = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.neonCyan.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppTheme.neonCyan),
                    ),
                    elevation: 0,
                  ).copyWith(
                    shadowColor: WidgetStateProperty.all(AppTheme.neonCyan),
                  ),
                  child: const Text(
                    'Generate Map',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.5,
      maxScale: 2.5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final centerX = constraints.maxWidth / 2;
          final centerY = constraints.maxHeight / 2 - 50;

          // Define nodes
          final rootNode = Offset(centerX, centerY);
          final topNode = Offset(centerX, centerY - 140);
          final leftNode = Offset(centerX - 130, centerY + 80);
          final rightNode = Offset(centerX + 130, centerY + 80);
          final bLeafLeft = Offset(centerX - 80, centerY + 200);
          final bLeafRight = Offset(centerX + 80, centerY + 200);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Connect lines
              CustomPaint(
                painter: _ConceptLinesPainter(
                  progress: 1.0,
                  connections: [
                    (topNode, rootNode),
                    (leftNode, rootNode),
                    (rightNode, rootNode),
                    (rootNode, bLeafLeft),
                    (rootNode, bLeafRight),
                  ],
                ),
                size: Size(constraints.maxWidth, constraints.maxHeight),
              ),

              // Sub-nodes (You can randomly generate text based on the major topic,
              // for now keeping the general structure but updating the root).
              _buildFloatingNode('Subtopic 1', topNode, 0),
              _buildFloatingNode('Subtopic 2', leftNode, 1),
              _buildFloatingNode('Subtopic 3', rightNode, 2),
              _buildFloatingNode('Subtopic 4', bLeafLeft, 3),
              _buildFloatingNode('Subtopic 5', bLeafRight, 4),

              // Central Root Node
              Positioned(
                left: rootNode.dx - 80,
                top: rootNode.dy - 40,
                child: _buildRootNode(_topic),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFloatingNode(String title, Offset position, int index) {
    return Positioned(
      left: position.dx - 60,
      top: position.dy - 30,
      child: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildRootNode(String title) {
    return Container(
      width: 160,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF0288D1).withOpacity(0.2),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: const Color(0xFF00E5FF),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.6),
            blurRadius: 25,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: const Color(0xFF7C4DFF).withOpacity(0.3),
            blurRadius: 40,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          shadows: [
            Shadow(color: Color(0xFF00E5FF), blurRadius: 10),
          ],
        ),
      ),
    );
  }
}

class _ConceptLinesPainter extends CustomPainter {
  final double progress;
  final List<(Offset, Offset)> connections;

  _ConceptLinesPainter({required this.progress, required this.connections});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.3)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    for (final connection in connections) {
      final p1 = connection.$1;
      final p2 = connection.$2;

      final currentDx = p1.dx + (p2.dx - p1.dx) * progress;
      final currentDy = p1.dy + (p2.dy - p1.dy) * progress;
      final currentP2 = Offset(currentDx, currentDy);

      canvas.drawLine(p1, currentP2, glowPaint);
      canvas.drawLine(p1, currentP2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConceptLinesPainter old) {
    return old.progress != progress || old.connections != connections;
  }
}
