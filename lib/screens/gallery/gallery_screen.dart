import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor:
          const Color(
            0xFF38104D,
          ),

          title: const Text('Gallery')
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://picsum.photos/seed/${index + 40}/400',
                  fit: BoxFit.cover,
                ),
                if (index % 3 == 0) // Dummy logic to show some as videos
                  const Center(
                    child: Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
