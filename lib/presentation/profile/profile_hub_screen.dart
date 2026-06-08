import 'package:flutter/material.dart';

class ProfileHubScreen extends StatelessWidget {
  final VoidCallback onSelectStylePreferences;
  const ProfileHubScreen({super.key, required this.onSelectStylePreferences});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System Account Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(leading: Icon(Icons.person), title: Text('User Profile Node')),
          ListTile(leading: const Icon(Icons.brush), title: const Text('Modify Style Chips Layout'), onTap: onSelectStylePreferences),
          SwitchListTile(title: const Text('Force Dark Palette Engine'), value: false, onChanged: (v) {}),
        ],
      ),
    );
  }
}