import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {'title': 'General Consultation', 'icon': Icons.medical_services, 'desc': 'Routine checkups and health advice.'},
      {'title': 'Mental Health Support', 'icon': Icons.psychology, 'desc': 'Professional counseling and therapy.'},
      {'title': 'Vaccination', 'icon': Icons.vaccines, 'desc': 'Immunization for all age groups.'},
      {'title': 'Emergency Care', 'icon': Icons.emergency, 'desc': '24/7 immediate medical assistance.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Our Services')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(service['icon'] as IconData, color: Colors.white),
              ),
              title: Text(service['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(service['desc'] as String),
            ),
          );
        },
      ),
    );
  }
}
