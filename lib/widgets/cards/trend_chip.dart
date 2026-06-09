import 'package:flutter/material.dart';

class TrendChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const TrendChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF6A5AE0),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class TrendRow extends StatelessWidget {
  final Function(String) onTrendTap;
  const TrendRow({super.key, required this.onTrendTap});

  @override
  Widget build(BuildContext context) {
    final trends = ['Minimalist', 'Streetwear', 'Vintage Academic', 'Techwear'];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trends.length,
        itemBuilder: (context, index) {
          return TrendChip(
            label: trends[index],
            onTap: () => onTrendTap(trends[index]),
          );
        },
      ),
    );
  }
}
