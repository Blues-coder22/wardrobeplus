import 'package:flutter/material.dart';

class OutfitDetailsScreen extends StatelessWidget {
  final String itemName;
  final VoidCallback onBack;
  const OutfitDetailsScreen({super.key, required this.itemName, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack), title: const Text('Garment Spec Metrics')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(itemName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Chip(label: Text('Official Configuration')),
            const SizedBox(height: 24),
            const Text('Fit: Slim Fit Regular\nColor Hex Code: Primary Muted Dark', style: TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}