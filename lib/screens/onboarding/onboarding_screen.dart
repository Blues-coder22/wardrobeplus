import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final PageController _bgController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;
  Timer? _autoTimer;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Your AI-Powered\nDigital Closet',
      subtitle: 'Organize your wardrobe, discover your style identity, and never say "I have nothing to wear" again.',
      emoji: '✨',
      gradientColors: [const Color(0xFF1A0533), const Color(0xFF0F0F1A)],
      accentColor: AppColors.accent,
    ),
    OnboardingPage(
      title: 'Dress Smart,\nDress Local',
      subtitle: 'Get outfit picks based on Nairobi\'s weather, culture, and the latest local fashion trends.',
      emoji: '🌤️',
      gradientColors: [const Color(0xFF051A40), const Color(0xFF0F0F1A)],
      accentColor: AppColors.primary,
    ),
    OnboardingPage(
      title: 'AI Stylist in\nYour Pocket',
      subtitle: 'Chat with your personal AI fashion advisor 24/7. Mix, match, and look amazing every day.',
      emoji: '🤖',
      gradientColors: [const Color(0xFF1A1005), const Color(0xFF0F0F1A)],
      accentColor: AppColors.accentOrange,
    ),
  ];

  // Fashion image URLs (using placeholder colors for demo — replace with real images)
  final List<List<Color>> _imageColors = [
    [const Color(0xFF8B5CF6), const Color(0xFFEC4899)],
    [const Color(0xFF3B82F6), const Color(0xFF06B6D4)],
    [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_currentPage < _pages.length - 1) {
        _nextPage();
      }
    });
  }

  void _nextPage() {
    final next = (_currentPage + 1) % _pages.length;
    _animateTo(next);
  }

  void _animateTo(int page) {
    _fadeController.reset();
    _slideController.reset();
    setState(() => _currentPage = page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
    _bgController.animateToPage(
      page,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    _bgController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final page = _pages[_currentPage];

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: page.gradientColors,
              ),
            ),
          ),

          // Fashion image collage (top 55% of screen)
          SizedBox(
            height: size.height * 0.58,
            child: Stack(
              children: [
                // Background sliding images grid
                PageView.builder(
                  controller: _bgController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _FashionImageGrid(colors: _imageColors[index]);
                  },
                ),

                // Dark overlay at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          page.gradientColors.last.withOpacity(0.95),
                        ],
                      ),
                    ),
                  ),
                ),

                // Logo overlay top-left
                Positioned(
                  top: 56,
                  left: 24,
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.style, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Wardrobe+',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Skip button
                if (_currentPage < _pages.length - 1)
                  Positioned(
                    top: 56,
                    right: 24,
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.48,
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emoji badge
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: page.accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: page.accentColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        '${page.emoji}  Fashion AI',
                        style: TextStyle(
                          color: page.accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Text(
                        page.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Subtitle
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Text(
                        page.subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Page indicators
                  Row(
                    children: List.generate(_pages.length, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        width: isActive ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? page.accentColor : Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: _currentPage == _pages.length - 1
                        ? _GradientButton(
                      label: 'Get Started',
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    )
                        : _GradientButton(
                      label: 'Continue',
                      onTap: _nextPage,
                      color: page.accentColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Login link
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
    );
  }
}

class _FashionImageGrid extends StatelessWidget {
  final List<Color> colors;
  const _FashionImageGrid({required this.colors});

  @override
  Widget build(BuildContext context) {
    // In production, replace these with real fashion images using Image.network()
    // e.g., images from Unsplash fashion category
    final items = [
      _FashionCard(color: colors[0], label: 'Street Style', icon: Icons.person),
      _FashionCard(color: colors[1], label: 'Casual Chic', icon: Icons.checkroom),
      _FashionCard(color: colors[0].withOpacity(0.7), label: 'Minimalist', icon: Icons.spa),
      _FashionCard(color: colors[1].withOpacity(0.7), label: 'Office Wear', icon: Icons.business_center),
      _FashionCard(color: colors[0].withOpacity(0.5), label: 'Evening', icon: Icons.star),
      _FashionCard(color: colors[1].withOpacity(0.5), label: 'Weekend', icon: Icons.wb_sunny),
    ];

    return GridView.count(
      crossAxisCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      childAspectRatio: 0.75,
      children: items,
    );
  }
}

class _FashionCard extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;
  const _FashionCard({required this.color, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color),
      child: Stack(
        children: [
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white.withOpacity(0.9), size: 20),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title, subtitle, emoji;
  final List<Color> gradientColors;
  final Color accentColor;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradientColors,
    required this.accentColor,
  });
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _GradientButton({required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: color != null
                ? [color!, color!.withOpacity(0.7)]
                : [AppColors.primary, AppColors.gradientEnd],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (color ?? AppColors.primary).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
