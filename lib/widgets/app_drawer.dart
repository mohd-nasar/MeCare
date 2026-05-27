import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/about/about_screen.dart';
import '../screens/gallery/gallery_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/mental_health/mental_health_screen.dart';
import '../screens/profile/profile_completion_screen.dart';
import '../services/theme_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'MindCare Menu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About Services'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GalleryScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month_outlined),
                  title: const Text('Appointment Calendar'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.psychology_outlined),
                  title: const Text('Mental Health Problems'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MentalHealthScreen()));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileCompletionScreen(isEditing: true)));
                  },
                ),
                // Dark Mode Toggle directly after Profile
                ListTile(
                  leading: Icon(themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: themeService.isDarkMode,
                    activeColor: const Color(0xFF00A67E),
                    onChanged: (value) {
                      themeService.toggleTheme(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'v1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
