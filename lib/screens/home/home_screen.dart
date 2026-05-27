import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/auth_service.dart';
import '../../data/dummy_data.dart';
import '../../widgets/app_drawer.dart';
import '../chat/chat_screen.dart';
import '../calendar/calendar_screen.dart';
import '../clinics/clinic_detail_screen.dart';
import '../doctors/doctor_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userName = authService.user?.displayName ?? "Guest";
    final doctor = dummyDoctors.first;
    final clinic = dummyClinics.first;

    // --- Core Branding Colors ---
    const brandPurple = Color(0xFF38104D);
    const brandOrange = Color(0xFF795DA1);
    const primaryTeal = Color(0xFF38104D);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final cardBg = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: scaffoldBg,
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          // Header Section
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: brandPurple,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: const Text(
              "MindCare Center",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [brandPurple, Color(0xFF5A2A7A)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 110, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, $userName",
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Your journey to wellness starts here.",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Doctor Highlight Card ---
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailScreen(doctor: doctor))),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(doctor.photoUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  doctor.specialization,
                                  style: const TextStyle(fontSize: 14, color: primaryTeal, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: brandOrange, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${doctor.experience} exp",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Upcoming Appointment Card ---
                  const Text(
                    "Upcoming Session",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: brandOrange,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: brandOrange.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.white, size: 20),
                            SizedBox(width: 10),
                            Text("Mon, 24 Oct", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            Spacer(),
                            Icon(Icons.access_time, color: Colors.white, size: 20),
                            SizedBox(width: 10),
                            Text("09:30 AM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const Divider(color: Colors.white24, height: 30),
                        Row(
                          children: [
                            const CircleAvatar(radius: 20, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Routine Checkup", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                Text("MindCare Center", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                            const Spacer(),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- NEW MODERN BUTTON LAYOUT ---
                  Row(
                    children: [
                      // Chat Button (Outlined)
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            side: BorderSide(color: isDark ? Colors.white24 : primaryTeal.withOpacity(0.5)),
                          ),
                          child: Text(
                            "Chat", 
                            style: TextStyle(
                              color: isDark ? Colors.white : primaryTeal, 
                              fontWeight: FontWeight.bold, 
                              fontSize: 16
                            )
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Book Appointment Button (Solid Teal)
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen())),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                          ),
                          child: const Text("Book Appointment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // --- Clinic Spotlight Card ---
                  const Text(
                    "Our Center",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClinicDetailScreen(clinic: clinic))),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: isDark ? Colors.black26 : Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(clinic.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: brandOrange, size: 16),
                                    const SizedBox(width: 4),
                                    Expanded(child: Text(clinic.address, style: const TextStyle(fontSize: 13, color: Colors.grey), maxLines: 2)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: DecorationImage(image: NetworkImage(clinic.imageUrl), fit: BoxFit.cover)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- Social Media Links ---
                  const Text("Connect with Us", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialIcon(icon: FontAwesomeIcons.instagram, color: const Color(0xFFE4405F), onTap: () => _launchURL("https://www.instagram.com/mindcareclinicsukkur/")),
                        _buildSocialIcon(icon: FontAwesomeIcons.tiktok, color: isDark ? Colors.white : Colors.black, onTap: () => _launchURL("https://www.tiktok.com/@mind.care.clinic?_r=1&_t=ZS-96hlnpusDmH")),
                        _buildSocialIcon(icon: FontAwesomeIcons.youtube, color: const Color(0xFFFF0000), onTap: () => _launchURL("https://youtube.com/@mindcareclinic-v8e?si=YNWnju84SItdjPPC")),
                        _buildSocialIcon(icon: FontAwesomeIcons.facebook, color: const Color(0xFF1877F2), onTap: () => _launchURL("https://www.facebook.com/share/1ELKS5A3vx/")),
                        _buildSocialIcon(icon: FontAwesomeIcons.mapLocationDot, color: brandOrange, onTap: () => _launchURL("https://maps.app.goo.gl/jER7Tuz2gifoZviE8")),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
        child: FaIcon(icon, color: color, size: 28),
      ),
    );
  }
}
