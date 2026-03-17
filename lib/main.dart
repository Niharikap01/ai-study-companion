import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const AIStudyCompanionApp());
}

class AIStudyCompanionApp extends StatelessWidget {
  const AIStudyCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Study Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
