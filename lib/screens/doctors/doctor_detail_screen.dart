import 'package:flutter/material.dart';
import '../../models/doctor.dart';
import '../../data/dummy_data.dart';
import '../chat/chat_screen.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final clinics = dummyClinics
        .where((clinic) => doctor.clinicIds.contains(clinic.id))
        .toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryGreen = Color(0xFF0F766E);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Doctor Details", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
        const Color(
          0xFF38104D,
        ),
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- Profile Header ---
            Center(
              child: Column(
                children: [
                  Hero(
                    tag: doctor.id,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryGreen, width: 4),
                        image: DecorationImage(
                          image: NetworkImage(doctor.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    doctor.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialization,
                    style: const TextStyle(fontSize: 16, color: primaryGreen, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.education,
                    style: TextStyle(fontSize: 14, color: isDark ? Colors.grey[400] : Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- Stats Row ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem("Experience", doctor.experience, Icons.history_edu_rounded),
                  _buildStatItem("Rating", "4.9", Icons.star_rounded),
                  _buildStatItem("Patients", "500+", Icons.people_rounded),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- Info Sections ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Biography"),
                  const SizedBox(height: 10),
                  Text(
                    "Dr. Najamuddin is a psychiatrist qualified by the Royal College of Psychiatrists in London, U.K., with over twenty years of experience. He has been working with the Ministry of Health in Brunei Darussalam since 2009.",
                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[700], height: 1.6),
                  ),
                  const SizedBox(height: 25),

                  _buildSectionHeader("Education"),
                  const SizedBox(height: 10),
                  _buildBulletPoint(doctor.education),
                  _buildBulletPoint("Member of Royal College of Psychiatrists, London"),
                  const SizedBox(height: 25),

                  _buildSectionHeader("Clinics"),
                  const SizedBox(height: 10),
                  ...clinics.map((clinic) => Card(
                    elevation: 0,
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: const Icon(Icons.location_on, color: primaryGreen),
                      title: Text(clinic.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(clinic.address, style: const TextStyle(fontSize: 12)),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  side: const BorderSide(color: primaryGreen),
                ),
                child: const Text("Chat", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text("Book Appointment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0F766E), size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: Color(0xFF0F766E), fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
