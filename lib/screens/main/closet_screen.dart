import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['All', 'Tops', 'Bottoms', 'Outerwear', 'Shoes', 'Accessories'];
  int _selectedCategory = 0;

  final List<_ClothingItem> _items = [
    const _ClothingItem(name: 'Black Blazer', category: 'Outerwear', color: Colors.black87, tags: ['office', 'formal'], wearCount: 12),
    const _ClothingItem(name: 'Denim Jacket', category: 'Outerwear', color: Color(0xFF1A4B8C), tags: ['casual'], wearCount: 8),
    const _ClothingItem(name: 'Summer Dress', category: 'Tops', color: Color(0xFF8B5CF6), tags: ['casual', 'summer'], wearCount: 5),
    const _ClothingItem(name: 'Chino Pants', category: 'Bottoms', color: Color(0xFFD4A574), tags: ['casual', 'office'], wearCount: 15),
    const _ClothingItem(name: 'White Linen Shirt', category: 'Tops', color: Colors.white70, tags: ['formal', 'summer'], wearCount: 7),
    const _ClothingItem(name: 'Ankara Jacket', category: 'Outerwear', color: Color(0xFFE67E22), tags: ['cultural', 'events'], wearCount: 3),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_ClothingItem> get _filteredItems {
    if (_selectedCategory == 0) return _items;
    final cat = _categories[_selectedCategory];
    return _items.where((i) => i.category == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Closet', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                        Text('6 items catalogued', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                      ],
                    ),
                  ),
                  _IconButton(icon: Icons.search_rounded, onTap: () {}),
                  const SizedBox(width: 8),
                  _IconButton(icon: Icons.filter_list_rounded, onTap: () {}),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.gradientEnd]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text('Add', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Category tabs
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final isActive = i == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isActive ? AppColors.primary : const Color(0xFF2A2A4A)),
                      ),
                      child: Text(
                        _categories[i],
                        style: TextStyle(
                          color: isActive ? Colors.white : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: _filteredItems.length,
                itemBuilder: (context, i) => _ClothingCard(item: _filteredItems[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClothingCard extends StatelessWidget {
  final _ClothingItem item;
  const _ClothingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A4A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(Icons.checkroom, color: item.color, size: 48),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(item.category, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    const Spacer(),
                    const Icon(Icons.replay, color: AppColors.textMuted, size: 11),
                    const SizedBox(width: 2),
                    Text('${item.wearCount}x', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: item.tags.take(2).map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(t, style: const TextStyle(color: AppColors.primary, fontSize: 9)),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClothingItem {
  final String name, category;
  final Color color;
  final List<String> tags;
  final int wearCount;
  const _ClothingItem({required this.name, required this.category, required this.color, required this.tags, required this.wearCount});
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2A2A4A)),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 18),
      ),
    );
  }
}
