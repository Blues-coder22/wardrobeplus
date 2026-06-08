import 'package:flutter/material.dart';

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
          return GestureDetector(
            onTap: () => onTrendTap(trends[index]),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(color: const Color(0xFF6A5AE0), borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Text(trends[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}