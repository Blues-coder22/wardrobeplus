import 'package:flutter/material.dart';

class AddClothingSheet extends StatelessWidget {
  const AddClothingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Add New Clothing Item', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          // Form fields
        ],
      ),
    );
  }
}
