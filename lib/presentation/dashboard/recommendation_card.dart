import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('✨', style: TextStyle(fontSize: 18)),
                SizedBox(width: 8),
                Text('AI Recommended Match Outfit', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6A5AE0))),
              ],
            ),
            const Divider(height: 24),
            const Text('🧥 Top: Classic Trench Coat (Beige)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const Text('👔 Inner: Black Blazer (Official)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const Text(' Pants: Slim Fit Chinos (Khaki)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}