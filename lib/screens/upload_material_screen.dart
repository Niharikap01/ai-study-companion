// lib/screens/upload_material_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/galaxy_background.dart';
import '../theme/app_theme.dart';

class UploadMaterialScreen extends StatefulWidget {
  const UploadMaterialScreen({super.key});

  @override
  State<UploadMaterialScreen> createState() => _UploadMaterialScreenState();
}

class _UploadMaterialScreenState extends State<UploadMaterialScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isDialogButtonHovered = false;
  bool _dragHover = false;

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected PDF: ${result.files.single.name}'),
          backgroundColor: AppTheme.deepPurple,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected Image: ${image.name}'),
          backgroundColor: AppTheme.deepPurple,
        ),
      );
    }
  }

  void _openNotes() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.backgroundDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: AppTheme.electricBlue.withValues(alpha: 0.5)),
              ),
              title:
                  const Text('Add Notes', style: TextStyle(color: Colors.white)),
              content: SizedBox(
                width: 400,
                child: TextField(
                  maxLines: 6,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type or paste your notes here...',
                    hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.neonCyan),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppTheme.neonCyan),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) =>
                      setDialogState(() => _isDialogButtonHovered = true),
                  onExit: (_) =>
                      setDialogState(() => _isDialogButtonHovered = false),
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _isDialogButtonHovered
                          ? [
                              BoxShadow(
                                color: AppTheme.electricBlue
                                    .withValues(alpha: 0.7),
                                blurRadius: 20,
                                spreadRadius: 1,
                              )
                            ]
                          : [],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notes Saved successfully!'),
                            backgroundColor: AppTheme.deepPurple,
                          ),
                        );
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isDialogButtonHovered
                                ? [
                                    AppTheme.electricBlue,
                                    AppTheme.tealAccent
                                  ]
                                : const [
                                    AppTheme.deepPurple,
                                    AppTheme.electricBlue
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 10.0),
                          child: Text(
                            'Save Notes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static const double _radius = 24.0;
  static const neonCyan = Color(0xFF00E5FF);
  static const electricBlue = Color(0xFF0288D1);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GalaxyBackground(),
        Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Upload Materials',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 100.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: RepaintBoundary(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: [
                        BoxShadow(
                          color: neonCyan.withValues(alpha: 0.2),
                          blurRadius: 32,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: electricBlue.withValues(alpha: 0.15),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_radius),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_radius),
                            color: Colors.white.withValues(alpha: 0.08),
                            border: Border.all(
                              color: neonCyan.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Upload or drop your study materials',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'PDF, images, or type notes below.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white70,
                                    ),
                              ),
                              const SizedBox(height: 24),
                              MouseRegion(
                                onEnter: (_) =>
                                    setState(() => _dragHover = true),
                                onExit: (_) =>
                                    setState(() => _dragHover = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 32, horizontal: 24),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                    color: Colors.white
                                        .withValues(
                                            alpha: _dragHover ? 0.08 : 0.04),
                                    border: Border.all(
                                      color: _dragHover
                                          ? neonCyan
                                              .withValues(alpha: 0.4)
                                          : Colors.white
                                              .withValues(alpha: 0.15),
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.cloud_upload_outlined,
                                        size: 48,
                                        color: neonCyan
                                            .withValues(alpha: 0.8),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Drag & drop files here',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.9),
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'or use the buttons below',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.6),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildUploadButton(
                                      label: 'Upload Image',
                                      icon: Icons.image_outlined,
                                      onTap: _pickImage,
                                      delay: 200,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildUploadButton(
                                      label: 'Upload PDF',
                                      icon: Icons.picture_as_pdf,
                                      onTap: _pickPDF,
                                      delay: 300,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: _buildUploadButton(
                                  label: 'Upload Notes',
                                  icon: Icons.description,
                                  onTap: _openNotes,
                                  delay: 400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.05, curve: Curves.easeOut),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required int delay,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withValues(alpha: 0.06),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: neonCyan.withValues(alpha: 0.15),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.neonCyan, size: 24),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: delay.ms, duration: 400.ms).slideY(begin: 0.1);
  }
}
