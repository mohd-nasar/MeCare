import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import 'clinic_detail_screen.dart';

class ClinicListTab extends StatelessWidget {
  const ClinicListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyClinics.length,
      itemBuilder: (context, index) {
        final clinic = dummyClinics[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClinicDetailScreen(clinic: clinic),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  clinic.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    clinic.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
