import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _staggerController;
  late Animation<double> _fadeAnim;

  // Master outfit pool — each tagged with the style it belongs to
  final List<_OutfitRecommendation> _allOutfits = [
    const _OutfitRecommendation(
      top: 'Classic Trench Coat (Beige)',
      inner: 'Black Blazer (Official)',
      pants: 'Slim-Fit Chinos (Khaki)',
      occasion: 'Office Ready',
      confidence: 96,
      color: AppColors.primary,
      styleId: 'business',
    ),
    const _OutfitRecommendation(
      top: 'White Linen Shirt',
      inner: 'No inner layer',
      pants: 'Dark Wash Jeans',
      occasion: 'Casual Chic',
      confidence: 88,
      color: AppColors.accent,
      styleId: 'minimalist',
    ),
    const _OutfitRecommendation(
      top: 'Ankara Print Jacket',
      inner: 'White Tee',
      pants: 'Black Skinny Jeans',
      occasion: 'Cultural Pride',
      confidence: 92,
      color: Color(0xFF10B981),
      styleId: 'afro-chic',
    ),
    const _OutfitRecommendation(
      top: 'Oversized Hoodie',
      inner: 'Graphic Tee',
      pants: 'Cargo Pants',
      occasion: 'Street Ready',
      confidence: 94,
      color: Color(0xFFFF6B9D),
      styleId: 'streetwear',
    ),
    const _OutfitRecommendation(
      top: 'Tech Shell Jacket',
      inner: 'Compression Top',
      pants: 'Tapered Joggers',
      occasion: 'Urban Tech',
      confidence: 90,
      color: Color(0xFF38BDF8),
      styleId: 'techwear',
    ),
    const _OutfitRecommendation(
      top: 'Tweed Blazer',
      inner: 'Cream Knit Vest',
      pants: 'Pleated Trousers',
      occasion: 'Campus Classic',
      confidence: 87,
      color: Color(0xFFA78BFA),
      styleId: 'vintage',
    ),
  ];

  // All possible trend tags
  final List<_TrendTag> _allTrends = [
    const _TrendTag(id: 'minimalist', label: 'Minimalist', emoji: '🤍', isHot: false),
    const _TrendTag(id: 'streetwear', label: 'Streetwear', emoji: '🧢', isHot: true),
    const _TrendTag(id: 'vintage', label: 'Vintage Academic', emoji: '📚', isHot: false),
    const _TrendTag(id: 'techwear', label: 'Techwear', emoji: '⚡', isHot: true),
    const _TrendTag(id: 'afro-chic', label: 'Afro-Chic', emoji: '🌍', isHot: true),
    const _TrendTag(id: 'business', label: 'Business Casual', emoji: '💼', isHot: false),
  ];

  // Which trend chips are currently active (multi-select)
  late Set<String> _selectedTrendIds;
  bool _initialisedFromPreference = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _staggerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
    _staggerController.forward();
    _selectedTrendIds = {};
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  /// Sorts outfits so the ones matching the user's saved style preference
  /// appear first, followed by everything else.
  List<_OutfitRecommendation> _personalizedOutfits(String? stylePreference) {
    if (stylePreference == null) return _allOutfits;

    final matched = _allOutfits.where((o) => o.styleId == stylePreference).toList();
    final rest = _allOutfits.where((o) => o.styleId != stylePreference).toList();
    return [...matched, ...rest];
  }

  String _styleLabel(String? styleId) {
    final match = _allTrends.firstWhere(
          (t) => t.id == styleId,
      orElse: () => const _TrendTag(id: '', label: 'Your Style', emoji: '✨', isHot: false),
    );
    return match.label;
  }

  String _styleEmoji(String? styleId) {
    final match = _allTrends.firstWhere(
          (t) => t.id == styleId,
      orElse: () => const _TrendTag(id: '', label: '', emoji: '✨', isHot: false),
    );
    return match.emoji;
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth provider so the dashboard rebuilds if the user's
    // saved style preference changes (e.g. they redo the quiz later)
    final auth = context.watch<AuthProvider>();
    final stylePreference = auth.user.stylePreference;

    // On first build, pre-select the user's saved style chip
    if (!_initialisedFromPreference && stylePreference != null) {
      _selectedTrendIds.add(stylePreference);
      _initialisedFromPreference = true;
    }

    final outfits = _personalizedOutfits(stylePreference);
    final userName = auth.user.name.isNotEmpty
        ? auth.user.name.split(' ').first
        : 'there';

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              backgroundColor: AppColors.dark,
              elevation: 0,
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.primary, AppColors.gradientEnd]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.style, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  const Text('Wardrobe+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  onPressed: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Greeting
                    Text(
                      'Good Morning, $userName! 👋',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Welcome Style Hub',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 20),

                    // Weather card
                    _WeatherCard(),
                    const SizedBox(height: 24),

                    // AI Recommendations — header changes based on preference
                    _SectionHeader(
                      title: stylePreference != null
                          ? 'Because you love ${_styleLabel(stylePreference)} ${_styleEmoji(stylePreference)}'
                          : 'AI Recommended Match Outfits',
                      subtitle: 'Based on today\'s weather & your style',
                      action: 'Refresh',
                      onAction: () => setState(() {}),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: outfits.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final isPersonalized = outfits[i].styleId == stylePreference;
                          return _OutfitCard(
                            outfit: outfits[i],
                            isPersonalized: isPersonalized,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Trending section — chips reflect saved preference
                    _SectionHeader(
                      title: 'Trending Layout Feeds',
                      subtitle: 'Nairobi & Global picks',
                      action: 'See all',
                      onAction: () {},
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _allTrends.map((t) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _TrendChip(
                            tag: t,
                            isSelected: _selectedTrendIds.contains(t.id),
                            isPreferred: t.id == stylePreference,
                            onTap: () {
                              setState(() {
                                if (_selectedTrendIds.contains(t.id)) {
                                  _selectedTrendIds.remove(t.id);
                                } else {
                                  _selectedTrendIds.add(t.id);
                                }
                              });
                            },
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Local vs Global toggle
                    _TrendingGrid(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A6E), Color(0xFF0F2040)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A4A8A), width: 0.5),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: AppColors.primary, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Nairobi, Kenya',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Cool & Cloud Covered',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '18°C',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Feels like 16°C', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                        Text('Humidity: 74%', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                        Text('Wind: 12 km/h NE', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Icon(Icons.cloud, color: Color(0xFF90CAF9), size: 48),
              SizedBox(height: 4),
              Text('Wear layers!', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title, subtitle, action;
  final VoidCallback onAction;
  const _SectionHeader({
    required this.title, required this.subtitle,
    required this.action, required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(action, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

class _OutfitCard extends StatelessWidget {
  final _OutfitRecommendation outfit;
  final bool isPersonalized;
  const _OutfitCard({required this.outfit, this.isPersonalized = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPersonalized ? outfit.color.withOpacity(0.6) : outfit.color.withOpacity(0.25),
          width: isPersonalized ? 1.5 : 1,
        ),
        boxShadow: isPersonalized
            ? [BoxShadow(color: outfit.color.withOpacity(0.18), blurRadius: 14, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: outfit.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  outfit.occasion,
                  style: TextStyle(color: outfit.color, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              if (isPersonalized)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Text('✨', style: TextStyle(fontSize: 11)),
                ),
              Text(
                '${outfit.confidence}%',
                style: TextStyle(color: outfit.color, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _OutfitItem(icon: Icons.dry_cleaning_outlined, label: outfit.top, color: outfit.color),
          const SizedBox(height: 6),
          _OutfitItem(icon: Icons.style_outlined, label: outfit.inner, color: outfit.color),
          const SizedBox(height: 6),
          _OutfitItem(icon: Icons.accessibility_new, label: outfit.pants, color: outfit.color),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: outfit.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Wear This',
                  style: TextStyle(color: outfit.color, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutfitItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _OutfitItem({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color.withOpacity(0.7), size: 12),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _TrendChip extends StatelessWidget {
  final _TrendTag tag;
  final bool isSelected;
  final bool isPreferred;
  final VoidCallback onTap;

  const _TrendChip({
    required this.tag,
    required this.isSelected,
    required this.isPreferred,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPreferred
                ? AppColors.primary
                : (isSelected ? AppColors.primary : const Color(0xFF2A2A4A)),
            width: isPreferred && !isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(tag.emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              tag.label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (tag.isHot) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('🔥', style: TextStyle(fontSize: 9)),
              ),
            ],
            if (isPreferred) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.star_rounded,
                color: isSelected ? Colors.white : AppColors.primary,
                size: 13,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TrendingGrid extends StatefulWidget {
  @override
  State<_TrendingGrid> createState() => _TrendingGridState();
}

class _TrendingGridState extends State<_TrendingGrid> {
  bool _showLocal = true;

  final List<Map<String, String>> _localTrends = [
    {'name': 'CBD Street Style', 'desc': 'Downtown Nairobi look', 'emoji': '🏙️'},
    {'name': 'Safari Chic', 'desc': 'Earthy tones + adventure', 'emoji': '🦁'},
    {'name': 'Matatu Culture', 'desc': 'Bold prints & color', 'emoji': '🎨'},
    {'name': 'Corporate Nairobi', 'desc': 'Smart professional', 'emoji': '💼'},
  ];

  final List<Map<String, String>> _globalTrends = [
    {'name': 'Y2K Revival', 'desc': 'Low rise & chrome accents', 'emoji': '✨'},
    {'name': 'Quiet Luxury', 'desc': 'Understated elegance', 'emoji': '🤍'},
    {'name': 'Dark Academia', 'desc': 'Vintage scholarly vibes', 'emoji': '📚'},
    {'name': 'Gorpcore', 'desc': 'Outdoor utility fashion', 'emoji': '🏔️'},
  ];

  @override
  Widget build(BuildContext context) {
    final trends = _showLocal ? _localTrends : _globalTrends;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _ToggleTab(label: '🌍 Local', isActive: _showLocal, onTap: () => setState(() => _showLocal = true)),
            const SizedBox(width: 8),
            _ToggleTab(label: '🌐 Global', isActive: !_showLocal, onTap: () => setState(() => _showLocal = false)),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
          ),
          itemCount: trends.length,
          itemBuilder: (context, i) {
            final t = trends[i];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2A2A4A)),
              ),
              child: Row(
                children: [
                  Text(t['emoji']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          t['name']!,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          t['desc']!,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _ToggleTab({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _OutfitRecommendation {
  final String top, inner, pants, occasion;
  final int confidence;
  final Color color;
  final String styleId;
  const _OutfitRecommendation({
    required this.top, required this.inner, required this.pants,
    required this.occasion, required this.confidence, required this.color,
    required this.styleId,
  });
}

class _TrendTag {
  final String id, label, emoji;
  final bool isHot;
  const _TrendTag({required this.id, required this.label, required this.emoji, required this.isHot});
}
