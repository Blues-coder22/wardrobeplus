import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class PremiumUpgradeScreen extends StatefulWidget {
  const PremiumUpgradeScreen({super.key});

  @override
  State<PremiumUpgradeScreen> createState() => _PremiumUpgradeScreenState();
}

class _PremiumUpgradeScreenState extends State<PremiumUpgradeScreen>
    with TickerProviderStateMixin {
  int _selectedPlan = 1; // 0=monthly, 1=yearly, 2=lifetime
  bool _isLoading = false;

  late AnimationController _entranceController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _particleController;

  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _shimmerAnim;
  late Animation<double> _particleAnim;

  final List<_Plan> _plans = const [
    _Plan(
      id: 0,
      label: 'Monthly',
      price: 'KES 499',
      period: '/month',
      annualTotal: 'KES 5,988/yr',
      badge: null,
      accentColor: AppColors.primary,
    ),
    _Plan(
      id: 1,
      label: 'Yearly',
      price: 'KES 299',
      period: '/month',
      annualTotal: 'KES 3,588/yr',
      badge: 'BEST VALUE',
      accentColor: Color(0xFFFF6B9D),
    ),
    _Plan(
      id: 2,
      label: 'Lifetime',
      price: 'KES 4,999',
      period: 'once',
      annualTotal: 'Pay once, own forever',
      badge: 'LIMITED',
      accentColor: Color(0xFFFFB74D),
    ),
  ];

  final List<_Feature> _features = const [
    _Feature(
      icon: Icons.auto_awesome,
      label: 'Unlimited AI Outfit Generation',
      sub: 'No daily limits — style whenever',
      color: Color(0xFFEC4899),
      free: false,
    ),
    _Feature(
      icon: Icons.wb_sunny_outlined,
      label: 'Real-time Weather Syncing',
      sub: 'Hyper-local Nairobi weather data',
      color: Color(0xFFFF8C42),
      free: true,
    ),
    _Feature(
      icon: Icons.trending_up_rounded,
      label: 'Global + Local Trend Insights',
      sub: 'KE, NG, ZA, UK, US & more',
      color: Color(0xFF38BDF8),
      free: false,
    ),
    _Feature(
      icon: Icons.checkroom_outlined,
      label: 'Unlimited Wardrobe Items',
      sub: 'Free tier is capped at 15 items',
      color: Color(0xFF34D399),
      free: false,
    ),
    _Feature(
      icon: Icons.calendar_month_outlined,
      label: '30-Day Outfit Planner',
      sub: 'Plan a full month in advance',
      color: Color(0xFFA78BFA),
      free: false,
    ),
    _Feature(
      icon: Icons.style_outlined,
      label: 'AI Body-Type Styling Engine',
      sub: 'Tailored to your exact figure',
      color: Color(0xFFFBBF24),
      free: false,
    ),
    _Feature(
      icon: Icons.download_outlined,
      label: 'Outfit Export & Sharing',
      sub: 'Share looks to IG, WhatsApp & more',
      color: Color(0xFFFF6B9D),
      free: false,
    ),
    _Feature(
      icon: Icons.support_agent_outlined,
      label: 'Priority Support',
      sub: '< 2h response time',
      color: Color(0xFF4ADE80),
      free: false,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _fadeAnim = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.1, 0.75, curve: Curves.easeOutCubic),
    ));
    _pulseAnim = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _shimmerAnim = Tween<double>(begin: -2, end: 3).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );
    _particleAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  String get _ctaLabel {
    switch (_selectedPlan) {
      case 0: return 'Start Monthly — KES 499';
      case 1: return 'Start Yearly — KES 299/mo';
      case 2: return 'Get Lifetime — KES 4,999';
      default: return 'Upgrade Now';
    }
  }

  Future<void> _handleUpgrade() async {
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      // Show success sheet
      _showSuccessSheet();
    }
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SuccessSheet(plan: _plans[_selectedPlan]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Animated background ──────────────────────────────
          _AnimatedBackground(particleAnim: _particleAnim),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: CustomScrollView(
                  slivers: [
                    // ── Close button + badge ─────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.white, size: 22),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.warning.withOpacity(0.4)),
                              ),
                              child: const Row(
                                children: [
                                  Text('⚡', style: TextStyle(fontSize: 12)),
                                  SizedBox(width: 5),
                                  Text('Limited-time offer',
                                      style: TextStyle(
                                          color: AppColors.warning,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Crown + headline ─────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            // Animated crown
                            ScaleTransition(
                              scale: _pulseAnim,
                              child: AnimatedBuilder(
                                animation: _shimmerAnim,
                                builder: (_, child) => ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: const [
                                      Color(0xFFFFD700),
                                      Color(0xFFFFF9C4),
                                      Color(0xFFFFD700),
                                      Color(0xFFFFAA00),
                                    ],
                                    stops: const [0.0, 0.4, 0.6, 1.0],
                                    begin: Alignment(_shimmerAnim.value, 0),
                                    end: Alignment(_shimmerAnim.value + 1, 0),
                                  ).createShader(bounds),
                                  child: child,
                                ),
                                child: const Text('👑', style: TextStyle(fontSize: 56)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Headline
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFFFAA00)],
                              ).createShader(bounds),
                              child: const Text(
                                'Wardrobe+\nPremium',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Unlock your full style potential.\nDress smarter, every single day.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                height: 1.65,
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                      ),
                    ),

                    // ── Plan selector ────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Choose your plan',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 14),
                            Row(
                              children: _plans.map((p) {
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: p.id < 2 ? 8 : 0),
                                    child: _PlanCard(
                                      plan: p,
                                      isSelected: _selectedPlan == p.id,
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                        setState(() => _selectedPlan = p.id);
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                            // Savings callout
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _selectedPlan == 1
                                  ? Container(
                                key: const ValueKey('savings'),
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B9D)
                                      .withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFFF6B9D)
                                          .withOpacity(0.25)),
                                ),
                                child: const Row(
                                  children: [
                                    Text('🎉',
                                        style: TextStyle(fontSize: 14)),
                                    SizedBox(width: 8),
                                    Text(
                                      'You save KES 2,400 per year!',
                                      style: TextStyle(
                                          color: Color(0xFFFF6B9D),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                                  : const SizedBox(key: ValueKey('no_savings')),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 28)),

                    // ── Feature list ─────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Everything you get",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 14),
                            ..._features.map((f) => _FeatureRow(feature: f)),
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 28)),

                    // ── Social proof ─────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _SocialProofCard(),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 28)),

                    // ── FAQ ──────────────────────────────────
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('FAQs',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(height: 12),
                            _FaqTile(
                              q: 'Can I cancel anytime?',
                              a: 'Yes! Monthly and yearly plans can be cancelled at any time from your account settings with no penalty.',
                            ),
                            _FaqTile(
                              q: 'Is there a free trial?',
                              a: 'Yes — all new accounts get a 7-day free trial on any plan. No card required for the trial.',
                            ),
                            _FaqTile(
                              q: 'What payment methods are accepted?',
                              a: 'M-Pesa, Visa, Mastercard, and PayPal are all supported.',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                ),
              ),
            ),
          ),

          // ── Sticky CTA ───────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: AppColors.dark.withOpacity(0.95),
                border: const Border(
                    top: BorderSide(color: Color(0xFF2A2A4A), width: 0.5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CTA button
                  GestureDetector(
                    onTap: _isLoading ? null : _handleUpgrade,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFAA00)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withOpacity(0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 2.5),
                        )
                            : Text(
                          _ctaLabel,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Restore + terms
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Restore purchase',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                      Text(' · ',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                      Text('Terms',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                      Text(' · ',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                      Text('Privacy',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                    ],
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

// ── Plan card ─────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final bool isSelected;
  final VoidCallback onTap;
  const _PlanCard({required this.plan, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? plan.accentColor.withOpacity(0.1)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? plan.accentColor : const Color(0xFF2A2A4A),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: plan.accentColor.withOpacity(0.2),
              blurRadius: 14,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Column(
          children: [
            // Badge
            if (plan.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: plan.accentColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  plan.badge!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5),
                ),
              )
            else
              const SizedBox(height: 0),
            // Plan name
            Text(
              plan.label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            // Price
            Text(
              plan.price,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              plan.period,
              style: TextStyle(
                color: isSelected
                    ? plan.accentColor.withOpacity(0.85)
                    : AppColors.textMuted,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 6),
            // Radio
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? plan.accentColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? plan.accentColor : const Color(0xFF3A3A5A),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 11)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Feature row ───────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  final _Feature feature;
  const _FeatureRow({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: feature.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: feature.color.withOpacity(0.2)),
            ),
            child: Icon(feature.icon, color: feature.color, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.label,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  feature.sub,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          feature.free
              ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('Free',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
          )
              : Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFAA00)]),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.star_rounded, color: Colors.black, size: 13),
          ),
        ],
      ),
    );
  }
}

// ── Social proof ──────────────────────────────────────────────────────────────

class _SocialProofCard extends StatelessWidget {
  final List<Map<String, String>> _reviews = const [
    {
      'name': 'Akinyi W.',
      'avatar': '👩🏾',
      'text': 'This app literally changed how I dress every morning. The AI outfits are scarily good!',
      'stars': '5',
    },
    {
      'name': 'David M.',
      'avatar': '👨🏾',
      'text': 'Finally an app that understands Nairobi weather and Kenyan style. 10/10.',
      'stars': '5',
    },
    {
      'name': 'Zuri K.',
      'avatar': '🧑🏽',
      'text': 'The premium plan is worth every shilling. Wardrobe is so organised now!',
      'stars': '5',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A2A4A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Stars
              Row(
                children: List.generate(5, (i) =>
                const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 18)),
              ),
              const SizedBox(width: 10),
              const Text('4.9 · 2,400+ reviews',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          ..._reviews.map((r) => _ReviewTile(review: r)),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Map<String, String> review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(review['avatar']!, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review['name']!,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(review['text']!,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── FAQ tile ──────────────────────────────────────────────────────────────────

class _FaqTile extends StatefulWidget {
  final String q, a;
  const _FaqTile({required this.q, required this.a});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _expanded = !_expanded);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A4A)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.q,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textMuted, size: 20),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: _expanded
                  ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Text(widget.a,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13, height: 1.6)),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Success sheet ─────────────────────────────────────────────────────────────

class _SuccessSheet extends StatelessWidget {
  final _Plan plan;
  const _SuccessSheet({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A4A),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),
          const Text('👑', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          const Text('Welcome to Premium!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            'Your ${plan.label} plan is now active.\nEnjoy unlimited style, on us.',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 15, height: 1.6),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // close sheet
              Navigator.pop(context); // close premium screen
            },
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFAA00)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const Center(
                child: Text('Start Styling 🎉',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated background ───────────────────────────────────────────────────────

class _AnimatedBackground extends StatelessWidget {
  final Animation<double> particleAnim;
  const _AnimatedBackground({required this.particleAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: particleAnim,
      builder: (_, __) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _BackgroundPainter(particleAnim.value),
        );
      },
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double t;
  _BackgroundPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Dark base
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppColors.dark,
    );

    // Top gradient orb (gold)
    final goldPaint = Paint()
      ..shader = RadialGradient(colors: [
        const Color(0xFFFFD700).withOpacity(0.12),
        Colors.transparent,
      ]).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.5, -60),
        radius: 300,
      ));
    canvas.drawCircle(Offset(size.width * 0.5, -60), 300, goldPaint);

    // Floating sparkles
    final sparklePaint = Paint()..color = const Color(0xFFFFD700).withOpacity(0.5);
    final positions = [
      Offset(size.width * 0.12, size.height * 0.15 + 20 * (t % 1)),
      Offset(size.width * 0.88, size.height * 0.22 + 15 * ((t + 0.3) % 1)),
      Offset(size.width * 0.05, size.height * 0.55 + 18 * ((t + 0.6) % 1)),
      Offset(size.width * 0.92, size.height * 0.6 + 12 * ((t + 0.1) % 1)),
      Offset(size.width * 0.25, size.height * 0.85 + 10 * ((t + 0.8) % 1)),
    ];
    for (final p in positions) {
      canvas.drawCircle(p, 2.5, sparklePaint);
    }
  }

  @override
  bool shouldRepaint(_BackgroundPainter old) => old.t != t;
}

// ── Data models ───────────────────────────────────────────────────────────────

class _Plan {
  final int id;
  final String label, price, period, annualTotal;
  final String? badge;
  final Color accentColor;
  const _Plan({
    required this.id, required this.label, required this.price,
    required this.period, required this.annualTotal,
    this.badge, required this.accentColor,
  });
}

class _Feature {
  final IconData icon;
  final String label, sub;
  final Color color;
  final bool free;
  const _Feature({
    required this.icon, required this.label,
    required this.sub, required this.color, required this.free,
  });
}
