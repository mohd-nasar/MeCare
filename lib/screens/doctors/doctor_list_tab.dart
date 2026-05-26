import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/doctor.dart';
import 'doctor_detail_screen.dart';

class DoctorListTab extends StatefulWidget {
  const DoctorListTab({super.key});

  @override
  State<DoctorListTab> createState() => _DoctorListTabState();
}

class _DoctorListTabState extends State<DoctorListTab> {
  String _searchQuery = '';
  String _selectedSpecialization = 'All';

  @override
  Widget build(BuildContext context) {
    final specializations = ['All', ...dummyDoctors.map((d) => d.specialization).toSet()];

    final filteredDoctors = dummyDoctors.where((doctor) {
      final matchesSearch = doctor.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSpecialization = _selectedSpecialization == 'All' || doctor.specialization == _selectedSpecialization;
      return matchesSearch && matchesSpecialization;
    }).toList();

    // Grouping by specialization
    final Map<String, List<Doctor>> groupedDoctors = {};
    for (var doctor in filteredDoctors) {
      groupedDoctors.putIfAbsent(doctor.specialization, () => []).add(doctor);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedSpecialization,
                items: specializations.map((spec) => DropdownMenuItem(value: spec, child: Text(spec))).toList(),
                onChanged: (value) => setState(() => _selectedSpecialization = value!),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: groupedDoctors.keys.map((spec) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      spec,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  ...groupedDoctors[spec]!.map((doctor) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(doctor.photoUrl),
                        ),
                        title: Text(doctor.name),
                        subtitle: Text(doctor.education),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorDetailScreen(doctor: doctor),
                            ),
                          );
                        },
                      )),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
