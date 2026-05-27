import 'package:flutter/material.dart';

class MentalHealthScreen extends StatelessWidget {
  const MentalHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor:
          const Color(
            0xFF38104D,
          ),

          title: const Text('Mental Health Resources')
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 24),
            const Text(
              'Understanding Mental Health',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Mental health includes our emotional, psychological, and social well-being. It affects how we think, feel, and act.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                // Link placeholder
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening WHO Resources...')),
                );
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Visit WHO Resources'),
            ),
          ],
        ),
      ),
    );
  }
}
