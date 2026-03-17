import 'package:flutter/material.dart';
import 'dart:ui';

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.all(24.0),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
