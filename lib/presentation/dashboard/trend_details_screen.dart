import 'package:flutter/material.dart';

class TrendDetailsScreen extends StatelessWidget {
  final String trendName;
  final VoidCallback onBack;
  const TrendDetailsScreen({super.key, required this.trendName, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack), title: Text('$trendName Lookbook Blueprint')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.style, size: 64)),
            const SizedBox(height: 16),
            Text('Fusing aesthetics for local climate trends.', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}