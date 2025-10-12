import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';
import '../screens/auth/login_screen.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Create a gradient background similar to the designs
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MusicBudColors.backgroundPrimary,
              MusicBudColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: MusicBudSpacing.lg,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spacer to push content to center
                const Spacer(flex: 2),
                
                // MusicBud logo area (placeholder)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: MusicBudColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      MusicBudSpacing.radiusXxl,
                    ),
                  ),
                  child: const Icon(
                    Icons.music_note_rounded,
                    size: 64,
                    color: MusicBudColors.primaryRed,
                  ),
                ),
                
                const SizedBox(height: MusicBudSpacing.xl),
                
                // Main heading
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Let's meet new people with\\nthe same taste in\\n",
                        style: MusicBudTypography.heading2,
                      ),
                      TextSpan(
                        text: "MusicBud",
                        style: MusicBudTypography.heading2.copyWith(
                          color: MusicBudColors.primaryRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: MusicBudSpacing.lg),
                
                // Subtitle
                Text(
                  'Connect with people who share your musical taste and discover new favorites together',
                  style: MusicBudTypography.bodyMedium.copyWith(
                    color: MusicBudColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(flex: 3),
                
                // Action buttons
                Column(
                  children: [
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text('Login'),
                      ),
                    ),
                    
                    const SizedBox(height: MusicBudSpacing.md),
                    
                    // Sign up button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigate to sign up
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sign up coming soon!')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: MusicBudColors.backgroundTertiary.withOpacity(0.5),
                          side: BorderSide.none,
                        ),
                        child: const Text('Sign up'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: MusicBudSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}