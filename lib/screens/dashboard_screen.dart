// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/galaxy_background.dart';
import '../widgets/feature_card.dart';
import 'flashcard_galaxy_screen.dart';
import 'dart:ui';
import 'upload_material_screen.dart';
import 'ai_summary_screen.dart';
import 'profile_screen.dart';
import 'smart_study_planner_screen.dart';
import 'concept_map_screen.dart';
import 'progress_universe_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String userName;

  const DashboardScreen({super.key, required this.userName});

  // UPDATED → .jpg instead of .png
  static const _flashcardsIconAsset = 'assets/images/flashcards_icon.jpg';
  static const _aiQuizIconAsset = 'assets/images/ai_quiz_icon.jpg';
  static const _notesIconAsset = 'assets/images/notes_icon.jpg';
  static const _studyPlannerIconAsset = 'assets/images/study_planner_icon.jpg';
  static const _progressTrackerIconAsset = 'assets/images/progress_icon.jpg';
  static const _communityIconAsset = 'assets/images/community_icon.jpg';

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMM d').format(DateTime.now());

    final features = [
      {
        'title': 'Upload Study Materials',
        'desc': 'Upload PDFs, notes, or images to analyze.',
        'imageUrl': _notesIconAsset,
      },
      {
        'title': 'AI Generated Summaries',
        'desc': 'Generate concise summaries instantly.',
        'imageUrl': _aiQuizIconAsset,
      },
      {
        'title': 'Flashcards & Quizzes',
        'desc': 'Auto-generate from uploaded content.',
        'imageUrl': _flashcardsIconAsset,
      },
      {
        'title': 'Smart Study Planner',
        'desc': 'Personalized plans based on your goals.',
        'imageUrl': _studyPlannerIconAsset,
      },
      {
        'title': 'Interactive Concept Maps',
        'desc': 'Visualize relationships dynamically.',
        'imageUrl': _communityIconAsset,
      },
      {
        'title': 'Progress Tracking',
        'desc': 'Track goals, performance, & streaks.',
        'imageUrl': _progressTrackerIconAsset,
      },
    ];

    return Stack(
      children: [
        const GalaxyBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todayDate,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.mintGreen,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                              ).animate().fadeIn(duration: 400.ms),

                              const SizedBox(height: 8),

                              Text(
                                'Welcome back,\n$userName!',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge,
                              ).animate().fadeIn(delay: 200.ms),

                              const SizedBox(height: 16),

                              Text(
                                'Let\'s make studying easier today.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                              ).animate().fadeIn(delay: 400.ms),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProfileScreen(userName: userName),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF00E5FF).withOpacity(0.1),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00E5FF).withOpacity(0.4),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFF00E5FF).withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Color(0xFF00E5FF),
                              size: 28,
                            ),
                          ),
                        ).animate().fadeIn(delay: 400.ms).scale(),

                        const SizedBox(width: 16),

                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          child: const CircleAvatar(
                            radius: 34,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person, color: Colors.white, size: 36),
                          ),
                        ).animate().fadeIn(delay: 400.ms).scale(),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 1.2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final feature = features[index];

                        return FeatureCard(
                          title: feature['title'] as String,
                          description: feature['desc'] as String,
                          imageUrl: feature['imageUrl'] as String,
                          index: index,
                          onTap: () {
                            switch (index) {
                              case 0:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const UploadMaterialScreen(),
                                  ),
                                );
                                break;

                              case 1:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AiSummaryScreen(),
                                  ),
                                );
                                break;

                              case 2:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const FlashcardGalaxyScreen(),
                                  ),
                                );
                                break;
                              case 3:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const SmartStudyPlannerScreen(),
                                  ),
                                );
                                break;
                              case 4:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ConceptMapScreen(),
                                  ),
                                );
                                break;
                              case 5:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ProgressUniverseScreen(),
                                  ),
                                );
                                break;
                            }
                          },
                        );
                      },
                      childCount: features.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}