import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/galaxy_background.dart';

class SmartStudyPlannerScreen extends StatefulWidget {
  const SmartStudyPlannerScreen({super.key});

  @override
  State<SmartStudyPlannerScreen> createState() =>
      _SmartStudyPlannerScreenState();
}

class _SmartStudyPlannerScreenState extends State<SmartStudyPlannerScreen> {
  final TextEditingController _examDateController = TextEditingController();
  final TextEditingController _subjectsController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  bool _isReminderEnabled = false;
  TimeOfDay? _reminderTime;
  bool _planGenerated = false;

  @override
  void dispose() {
    _examDateController.dispose();
    _subjectsController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00E5FF),
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A2E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _examDateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00E5FF),
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A2E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _reminderTime = pickedTime;
      });
    }
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
              'Your Smart Study Plan',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildInputForm().animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                  const SizedBox(height: 32),
                  if (_planGenerated) ...[
                    _buildGeneratedPlan().animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
                  ]
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.1),
            blurRadius: 24,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: padding ?? const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Plan Setup',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _examDateController,
            label: 'Exam Date',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: _selectDate,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _subjectsController,
            label: 'Subjects (e.g., Math, Physics)',
            icon: Icons.menu_book,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _hoursController,
            label: 'Daily Study Hours',
            icon: Icons.access_time,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: _isReminderEnabled ? const Color(0xFF00E5FF) : Colors.white54,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enable Study Reminder',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      if (_isReminderEnabled && _reminderTime != null)
                        Text(
                          'Reminding at ${_reminderTime!.format(context)}',
                          style: const TextStyle(
                            color: Color(0xFF00E5FF),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: _isReminderEnabled,
                activeColor: const Color(0xFF00E5FF),
                onChanged: (val) {
                  setState(() {
                    _isReminderEnabled = val;
                  });
                  if (val && _reminderTime == null) {
                    _selectTime();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _planGenerated = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF).withOpacity(0.2),
              foregroundColor: const Color(0xFF00E5FF),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Generate Study Plan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00E5FF)),
        ),
      ),
    );
  }

  Widget _buildGeneratedPlan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Generated Plan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildDayPlan(
          day: 'Monday',
          tasks: [
            {'subject': 'Physics', 'time': '2h'},
            {'subject': 'Chemistry', 'time': '1h'},
          ],
        ),
        const SizedBox(height: 16),
        _buildDayPlan(
          day: 'Tuesday',
          tasks: [
            {'subject': 'Math', 'time': '2h'},
            {'subject': 'Revision', 'time': '1h'},
          ],
        ),
      ],
    );
  }

  Widget _buildDayPlan({
    required String day,
    required List<Map<String, String>> tasks,
  }) {
    return _buildGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny, color: Colors.orangeAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                day,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tasks.map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00E5FF),
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.only(right: 12),
                    ),
                    Expanded(
                      child: Text(
                        task['subject']!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5FF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF00E5FF).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        task['time']!,
                        style: const TextStyle(
                          color: Color(0xFF00E5FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
