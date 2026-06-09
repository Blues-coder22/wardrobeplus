import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final List<_PlannerEntry> _entries = [
    const _PlannerEntry(day: 1, label: 'Day 1 Outfits Block', worn: 'Black Blazer + White Shirt', date: 'Mon, Jun 2'),
    const _PlannerEntry(day: 2, label: 'Day 2 Outfits Block', worn: 'Denim Jacket + Jeans', date: 'Tue, Jun 3'),
    const _PlannerEntry(day: 3, label: 'Day 3 Outfits Block', worn: 'Ankara Jacket + Chinos', date: 'Wed, Jun 4'),
    const _PlannerEntry(day: 4, label: 'Day 4 Outfits Block', worn: 'Trench Coat + Slim Fit', date: 'Thu, Jun 5'),
    const _PlannerEntry(day: 5, label: 'Day 5 Outfits Block', worn: 'Linen Shirt + Chinos', date: 'Fri, Jun 6', isToday: true),
    const _PlannerEntry(day: 6, label: 'Day 6 Outfits Block', worn: 'Casual Tee + Jeans', date: 'Sat, Jun 7', isPlanned: true),
    const _PlannerEntry(day: 7, label: 'Day 7 Outfits Block', worn: 'Sunday Best Suit', date: 'Sun, Jun 8', isPlanned: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chronological', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                        Text('Log Planner', style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF2A2A4A)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 16),
                          SizedBox(width: 6),
                          Text('June 2026', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stats row
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _StatChip(label: '5 Logged', color: AppColors.success),
                  SizedBox(width: 8),
                  _StatChip(label: '2 Planned', color: AppColors.warning),
                  SizedBox(width: 8),
                  _StatChip(label: '71% Unique', color: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _entries.length,
                itemBuilder: (context, i) => _PlannerCard(entry: _entries[i], isLast: i == _entries.length - 1),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Log Outfit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _PlannerCard extends StatelessWidget {
  final _PlannerEntry entry;
  final bool isLast;
  const _PlannerCard({required this.entry, required this.isLast});

  Color get _dotColor {
    if (entry.isToday) return AppColors.primary;
    if (entry.isPlanned) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: entry.isToday ? AppColors.primary : _dotColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: entry.isToday
                        ? null
                        : Border.all(color: _dotColor.withOpacity(0.4)),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.day}',
                      style: TextStyle(
                        color: entry.isToday ? Colors.white : _dotColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: const Color(0xFF2A2A4A),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: entry.isToday ? AppColors.primary.withOpacity(0.1) : AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: entry.isToday ? AppColors.primary.withOpacity(0.3) : const Color(0xFF2A2A4A),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              entry.label,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            if (entry.isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('Today', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.worn,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.date,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    entry.isPlanned ? Icons.edit_outlined : Icons.check_circle_outline,
                    color: _dotColor.withOpacity(0.6),
                    size: 18,
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

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}

class _PlannerEntry {
  final int day;
  final String label, worn, date;
  final bool isToday, isPlanned;
  const _PlannerEntry({
    required this.day, required this.label, required this.worn, required this.date,
    this.isToday = false, this.isPlanned = false,
  });
}
