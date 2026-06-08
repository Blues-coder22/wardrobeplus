import 'package:flutter/material.dart';
import 'garment_card.dart';

class ClosetGridScreen extends StatelessWidget {
  final Function(String) onSelectCard;
  const ClosetGridScreen({super.key, required this.onSelectCard});

  @override
  Widget build(BuildContext context) {
    final clothingItems = ['Black Blazer', 'Denim Jacket', 'Summer Dress', 'Chino Pants'];
    return Scaffold(
      appBar: AppBar(title: const Text('My Closet Inventory')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: clothingItems.length,
        itemBuilder: (context, index) {
          return GarmentCard(
            name: clothingItems[index],
            category: 'Casual Collection',
            onTap: () => onSelectCard(clothingItems[index]),
          );
        },
      ),
    );
  }
}