// lib/widgets/feature_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FeatureCard extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final int index;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.index,
    required this.onTap,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  static const double _radius = 20.0;

  static const neonCyan = Color(0xFF00E5FF);
  static const electricBlue = Color(0xFF0288D1);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              boxShadow: [
                BoxShadow(
                  color: neonCyan.withOpacity(_isHovered ? 0.5 : 0.2),
                  blurRadius: _isHovered ? 32 : 18,
                ),
                BoxShadow(
                  color: electricBlue.withOpacity(0.2),
                  blurRadius: 14,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(_radius),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 65,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(_radius),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AnimatedScale(
                                scale: _isHovered ? 1.08 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: Image.asset(
                                  widget.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                color: neonCyan.withOpacity(_isHovered ? 0.2 : 0.1),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0x99000000),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 35,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.title,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    widget.description,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
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
                ),
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (200 + widget.index * 150).ms)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}
