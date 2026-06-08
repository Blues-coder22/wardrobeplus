import 'package:flutter/material.dart';
import '../components/custom_buttons.dart';

class BodyTypeQuizScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const BodyTypeQuizScreen({super.key, required this.onComplete});

  @override
  State<BodyTypeQuizScreen> createState() => _BodyTypeQuizScreenState();
}

class _BodyTypeQuizScreenState extends State<BodyTypeQuizScreen> {
  String? selectedShape = 'Rectangle';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Architecture Quiz'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your General Form Parameter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Using modern Radio choices to fully satisfy the static analyzer
            ...['Rectangle', 'Hourglass', 'Inverted Triangle', 'Oval'].map((shape) {
              return RadioMenuButton<String>(
                value: shape,
                groupValue: selectedShape,
                onChanged: (String? val) {
                  setState(() {
                    selectedShape = val;
                  });
                },
                child: Text(
                  shape,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }), // Removed .toList() here to clear the "Unnecessary use of toList in a spread" hint

            const Spacer(),
            PrimaryBrandButton(
              text: 'Complete Setup',
              onPressed: widget.onComplete,
            ),
          ],
        ),
      ),
    );
  }
}