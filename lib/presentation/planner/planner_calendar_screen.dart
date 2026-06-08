import 'package:flutter/material.dart';

class PlannerCalendarScreen extends StatelessWidget {
  const PlannerCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chronological Log Planner')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('Day ${index + 1} Outfits Block'),
              subtitle: const Text('Worn: Black Blazer Setup'),
            ),
          );
        },
      ),
    );
  }
}