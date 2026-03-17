// lib/screens/ai_summary_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/galaxy_background.dart';
import '../theme/app_theme.dart';
import '../widgets/summary_diagram_widget.dart';

class AiSummaryScreen extends StatefulWidget {
  const AiSummaryScreen({super.key});

  @override
  State<AiSummaryScreen> createState() => _AiSummaryScreenState();
}

class _AiSummaryScreenState extends State<AiSummaryScreen> {
  final TextEditingController _topicController = TextEditingController();
  String? _generatedSummary;
  List<String> _keyPoints = const [];
  bool _isLoading = false;

  static const double _radius = 20.0;
  static const neonCyan = Color(0xFF00E5FF);
  static const electricBlue = Color(0xFF0288D1);

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  ({String summaryText, List<String> keyPoints}) generateSummary(String topic) {
    final t = topic.trim();
    if (t.isEmpty) {
      return (
        summaryText: 'Enter a topic to generate a summary.',
        keyPoints: const [],
      );
    }

    String paragraph;
    List<String> points;

    switch (t.toLowerCase()) {
      case 'photosynthesis':
        paragraph =
            'Photosynthesis is the process plants use to convert sunlight into chemical energy, using water and carbon dioxide to produce glucose and oxygen.';
        points = const [
          'Sunlight',
          'Chlorophyll',
          'Carbon Dioxide',
          'Water',
          'Glucose',
          'Oxygen',
        ];
        break;
      case "newton's laws":
      case 'newtons laws':
        paragraph =
            'Newton’s Laws describe how forces affect motion, forming the foundation of classical mechanics and predicting how objects accelerate and interact.';
        points = const [
          'Inertia',
          'Force',
          'Acceleration',
          'Mass',
          'Action–Reaction',
          'Net Force',
        ];
        break;
      default:
        paragraph =
            'Here’s a structured overview of "$t" with the most important ideas, terms, and relationships to help you study faster.';
        points = _extractKeyPointsFromTopic(t);
        break;
    }

    final summary = StringBuffer()
      ..writeln(t)
      ..writeln()
      ..writeln(paragraph)
      ..writeln()
      ..writeln('Key concepts:')
      ..writeln(points.map((e) => '• $e').join('\n'));

    return (summaryText: summary.toString(), keyPoints: points);
  }

  List<String> _extractKeyPointsFromTopic(String topic) {
    final seed = topic
        .replaceAll(RegExp(r'[\(\)\[\]\{\},:;]'), ' ')
        .split(RegExp(r'\s+'))
        .map((s) => s.trim())
        .where((s) => s.length >= 4)
        .toList();

    final out = <String>[];
    void add(String s) {
      final v = s.trim();
      if (v.isEmpty) return;
      if (out.contains(v)) return;
      out.add(v);
    }

    if (seed.isNotEmpty) {
      add(_toTitle(seed.first));
    }

    const defaults = [
      'Definition',
      'Core Components',
      'Process Flow',
      'Key Terms',
      'Examples',
      'Applications',
      'Common Mistakes',
    ];

    for (final d in defaults) {
      if (out.length >= 6) break;
      add(d);
    }

    while (out.length < 5) {
      add('Key Idea');
    }
    return out.take(7).toList();
  }

  String _toTitle(String s) {
    if (s.isEmpty) return s;
    final lower = s.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }

  Future<void> _onGenerateFromTopic() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a topic.'),
          backgroundColor: AppTheme.deepPurple,
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
      _generatedSummary = null;
      _keyPoints = const [];
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      final result = generateSummary(topic);
      _generatedSummary = result.summaryText;
      _keyPoints = result.keyPoints;
      _isLoading = false;
    });
  }

  Future<void> _onUploadImage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image upload for AI summarization — coming soon.'),
        backgroundColor: AppTheme.deepPurple,
      ),
    );
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
            title: Text(
              'AI Summary Generator',
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 980;
              final padding = EdgeInsets.fromLTRB(
                24,
                16,
                24,
                16 + MediaQuery.of(context).padding.bottom,
              );

              final inputPanel = _buildInputPanel();
              final outputPanel = _buildOutputPanel();

              if (!isWide) {
                return SingleChildScrollView(
                  padding: padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      inputPanel,
                      const SizedBox(height: 18),
                      outputPanel,
                    ],
                  ),
                );
              }

              return Padding(
                padding: padding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),
                            inputPanel,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 7,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),
                            outputPanel,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInputPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        color: Colors.white.withValues(alpha: 0.07),
        border: Border.all(
          color: neonCyan.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: neonCyan.withValues(alpha: 0.14),
            blurRadius: 18,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: electricBlue.withValues(alpha: 0.10),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Input Panel',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _topicController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Topic',
                  labelStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                  hintText: 'e.g., Photosynthesis, Newton\'s Laws...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.06),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: neonCyan.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _onUploadImage,
                  icon: const Icon(Icons.upload_file, size: 22),
                  label: const Text('Upload Image'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: neonCyan.withValues(alpha: 0.55),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onGenerateFromTopic,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.06),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.white12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: neonCyan.withValues(alpha: 0.55),
                      ),
                    ),
                    elevation: 0,
                    shadowColor: neonCyan.withValues(alpha: 0.35),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.neonCyan,
                          ),
                        )
                      : const Text('Generate Summary'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutputPanel() {
    final hasSummary =
        _generatedSummary != null && _generatedSummary!.trim().isNotEmpty;
    final topic = _topicController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSummaryOutput(hasSummary ? _generatedSummary! : null),
        const SizedBox(height: 16),
        _buildDiagramCard(
          topic: topic.isEmpty ? 'Topic' : topic,
          keyPoints: _keyPoints,
          enabled: hasSummary,
        ),
      ],
    );
  }

  Widget _buildSummaryOutput(String? text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: [
          BoxShadow(
            color: neonCyan.withValues(alpha: 0.20),
            blurRadius: 26,
          ),
          BoxShadow(
            color: electricBlue.withValues(alpha: 0.12),
            blurRadius: 18,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: neonCyan.withValues(alpha: 0.40),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Generated Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.neonCyan,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: 140, maxHeight: 320),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      (text ?? 'Generate a summary to see results here.').trim(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.55,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiagramCard({
    required String topic,
    required List<String> keyPoints,
    required bool enabled,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: [
          BoxShadow(
            color: neonCyan.withValues(alpha: enabled ? 0.18 : 0.10),
            blurRadius: enabled ? 26 : 18,
          ),
          BoxShadow(
            color: electricBlue.withValues(alpha: enabled ? 0.12 : 0.08),
            blurRadius: 18,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              color: Colors.white.withValues(alpha: 0.07),
              border: Border.all(
                color: neonCyan.withValues(alpha: enabled ? 0.40 : 0.22),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Concept Galaxy Diagram',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                AnimatedOpacity(
                  opacity: enabled ? 1 : 0.55,
                  duration: const Duration(milliseconds: 200),
                  child: SummaryDiagramWidget(
                    topic: topic,
                    keyPoints: keyPoints,
                    height: 320,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}