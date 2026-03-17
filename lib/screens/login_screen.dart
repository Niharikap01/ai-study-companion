// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/galaxy_background.dart';
import '../widgets/glassmorphic_container.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _academicLevel;
  String? _fieldOfStudy;
  String? _currentSubjects;

  final List<String> _levels = ['School', 'Undergraduate', 'Postgraduate'];
  final List<String> _fields = ['Engineering', 'Medicine', 'Commerce', 'Arts', 'Other'];

  bool _isButtonHovered = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) =>
              DashboardScreen(userName: _name ?? 'Student'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var fade = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut));
            var slide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
                .animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

            return FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: slide,
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const neonCyan = Color(0xFF00E5FF);
    const electricBlue = Color(0xFF0288D1);

    return Stack(
      children: [
        const GalaxyBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: RepaintBoundary(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: neonCyan.withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: electricBlue.withValues(alpha: 0.15),
                        blurRadius: 60,
                        spreadRadius: -10,
                      ),
                    ],
                  ),
                  child: GlassmorphicContainer(
                    width: 450,
                    borderRadius: 28,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'AI Study Companion',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppTheme.electricBlue,
                                  shadows: [
                                    Shadow(
                                      color: AppTheme.electricBlue.withValues(alpha: 0.5),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                            textAlign: TextAlign.center,
                          ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
                          const SizedBox(height: 8),
                          Text(
                            'Personalize your learning journey',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                          ).animate().fadeIn(delay: 200.ms),
                          const SizedBox(height: 32),
                          _buildTextField('Full Name', (val) => _name = val)
                              .animate()
                              .fadeIn(delay: 400.ms)
                              .slideX(begin: -0.1),
                          const SizedBox(height: 16),
                          _buildTextField('Email', (val) => _email = val, isEmail: true)
                              .animate()
                              .fadeIn(delay: 500.ms)
                              .slideX(begin: -0.1),
                          const SizedBox(height: 16),
                          _buildDropdown(
                                  'Academic Level', _levels, (val) => _academicLevel = val)
                              .animate()
                              .fadeIn(delay: 600.ms)
                              .slideX(begin: -0.1),
                          const SizedBox(height: 16),
                          _buildDropdown(
                                  'Field of Study', _fields, (val) => _fieldOfStudy = val)
                              .animate()
                              .fadeIn(delay: 700.ms)
                              .slideX(begin: -0.1),
                          const SizedBox(height: 16),
                          _buildTextField(
                                  'Current Subjects', (val) => _currentSubjects = val)
                              .animate()
                              .fadeIn(delay: 800.ms)
                              .slideX(begin: -0.1),
                          const SizedBox(height: 32),
                          MouseRegion(
                            onEnter: (_) => setState(() => _isButtonHovered = true),
                            onExit: (_) => setState(() => _isButtonHovered = false),
                            cursor: SystemMouseCursors.click,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _isButtonHovered
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.electricBlue.withValues(alpha: 0.6),
                                          blurRadius: 24,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.4),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                              ),
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _isButtonHovered
                                          ? [
                                              AppTheme.electricBlue,
                                              AppTheme.tealAccent,
                                            ]
                                          : const [
                                              AppTheme.deepPurple,
                                              AppTheme.electricBlue,
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Start My AI Study Journey',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: 1000.ms).scale(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, Function(String?) onSaved,
      {bool isEmail = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.neonCyan),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (val) => val == null || val.isEmpty ? 'Please enter $label' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildDropdown(
      String label, List<String> items, Function(String?) onSaved) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      dropdownColor: AppTheme.backgroundLight,
      style: const TextStyle(color: Colors.white),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (val) {},
      validator: (val) => val == null ? 'Please select $label' : null,
      onSaved: onSaved,
    );
  }
}
