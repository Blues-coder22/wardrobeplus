import 'package:flutter/material.dart';

class StylePreferencesScreen extends StatelessWidget {
  final VoidCallback onBack;
  const StylePreferencesScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final tags = ['Corporate', 'Vintage', 'Athleisure', 'Casual Chic'];
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack), title: const Text('Preference Matrices')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: tags.map((tag) => FilterChip(label: Text(tag), selected: true, onSelected: (b) {})).toList(),
        ),
      ),
    );
  }
}