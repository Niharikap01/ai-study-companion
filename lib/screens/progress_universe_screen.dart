import 'package:flutter/material.dart';
import '../widgets/galaxy_background.dart';

class ProgressUniverseScreen extends StatelessWidget {
  const ProgressUniverseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Reuse existing galaxy background
        const GalaxyBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Progress Universe'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          body: const SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _ProgressRing(
                      title: 'Study Hours',
                      value: '42h',
                      progress: 0.7,
                      color: Color(0xFF00E5FF),
                    ),
                    SizedBox(height: 48),
                    _ProgressRing(
                      title: 'Completed Topics',
                      value: '15',
                      progress: 0.5,
                      color: Color(0xFF7C4DFF),
                    ),
                    SizedBox(height: 48),
                    _ProgressRing(
                      title: 'Current Streak',
                      value: '7 Days',
                      progress: 0.85,
                      color: Color(0xFF0288D1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final String title;
  final String value;
  final double progress;
  final Color color;

  const _ProgressRing({
    required this.title,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Simple animated circular progress
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, val, _) {
                  return CircularProgressIndicator(
                    value: val,
                    strokeWidth: 10,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    color: color,
                    strokeCap: StrokeCap.round,
                  );
                },
              ),
              Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}
