import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Stylist Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ChatBubble(text: "Hello! Ask me to mix anything from your virtual layout collections.", isAI: true),
                ChatBubble(text: "What goes well with my Beige Trench Coat?", isAI: false),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Ask your fashion terminal...', border: OutlineInputBorder()))),
                IconButton(icon: const Icon(Icons.send), onPressed: () {}),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isAI;
  const ChatBubble({super.key, required this.text, required this.isAI});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: isAI ? Colors.deepPurple[100] : Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        child: Text(text),
      ),
    );
  }
}