import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/galaxy_background.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

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
              'Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Hero(
                    tag: 'profile-avatar',
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color(0xFF00E5FF).withOpacity(0.2),
                      child: const CircleAvatar(
                        radius: 56,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=47',
                        ),
                      ),
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 24),
                  Text(
                    userName,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 28,
                        ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  Text(
                    'student@example.com',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                  const SizedBox(height: 40),
                  _buildGlassCard(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileItem(
                          icon: Icons.local_fire_department,
                          title: 'Study Streak',
                          value: '14 Days',
                          color: Colors.orangeAccent,
                        ),
                        const Divider(color: Colors.white24, height: 32),
                        _buildProfileItem(
                          icon: Icons.timer,
                          title: 'Total Study Hours',
                          value: '124 Hours',
                          color: const Color(0xFF00E5FF),
                        ),
                        const Divider(color: Colors.white24, height: 32),
                        _buildProfileItem(
                          icon: Icons.library_books,
                          title: 'Subjects of Interest',
                          value: 'Physics, Math, Biology',
                          color: const Color(0xFF7C4DFF),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.edit,
                          label: 'Edit Profile',
                          onTap: () {},
                          isPrimary: true,
                        ),
                      ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.logout,
                          label: 'Logout',
                          onTap: () {
                            // TODO: Add logout logic
                          },
                          isPrimary: false,
                        ),
                      ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.2),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard(BuildContext context, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary
              ? const Color(0xFF00E5FF).withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary
                ? const Color(0xFF00E5FF).withOpacity(0.5)
                : Colors.white.withOpacity(0.2),
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? const Color(0xFF00E5FF) : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? const Color(0xFF00E5FF) : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
