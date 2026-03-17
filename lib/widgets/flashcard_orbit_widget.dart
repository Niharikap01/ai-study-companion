import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class FlashcardOrbitWidget extends StatefulWidget {
  final String term;
  final String definition;
  final String imagePath;
  final double? width;
  final double? height;

  const FlashcardOrbitWidget({
    super.key,
    required this.term,
    required this.definition,
    required this.imagePath,
    this.width,
    this.height,
  });

  @override
  State<FlashcardOrbitWidget> createState() => _FlashcardOrbitWidgetState();
}

class _FlashcardOrbitWidgetState extends State<FlashcardOrbitWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flip() {
    if (_flipController.isCompleted) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width ?? 200.0;
    final h = widget.height ?? 260.0;

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _flip,
          child: AnimatedScale(
            scale: _hover ? 1.06 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: AnimatedBuilder(
              animation: _flipController,
              builder: (context, child) {
                final angle = _flipController.value * pi;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  child: _buildCard(w, h, angle),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(double w, double h, double angle) {
    const radius = 20.0;
    const neonCyan = Color(0xFF00E5FF);
    const electricBlue = Color(0xFF0288D1);

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: neonCyan.withOpacity(0.4),
            blurRadius: _hover ? 28 : 18,
            spreadRadius: _hover ? 2 : 0,
          ),
          BoxShadow(
            color: electricBlue.withOpacity(0.25),
            blurRadius: 14,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: Colors.white.withOpacity(0.12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: angle < pi / 2 ? _front(w, h) : _back(w, h),
          ),
        ),
      ),
    );
  }

  Widget _front(double w, double h) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.white12,
                    child: const Icon(Icons.image_not_supported, color: Colors.white54, size: 48),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.term,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tap to view explanation',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _back(double w, double h) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(pi),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.6),
                    colorBlendMode: BlendMode.darken,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.white12,
                      child: const Icon(Icons.image_not_supported, color: Colors.white54, size: 48),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    widget.term,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF00E5FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.definition,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
