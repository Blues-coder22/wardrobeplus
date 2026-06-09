import 'package:flutter/material.dart';

class ClothingCard extends StatelessWidget {
  final String name;
  final String category;
  final VoidCallback onTap;

  const ClothingCard({
    super.key,
    required this.name,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text('👕', style: TextStyle(fontSize: 40)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                category,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
