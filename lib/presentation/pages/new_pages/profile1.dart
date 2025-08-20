
import 'package:flutter/material.dart';

class Profile1Page extends StatelessWidget {
  const Profile1Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/cover.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  top: 140,
                  left: 20,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                ),
                const Positioned(
                  top: 160,
                  left: 120,
                  child: Text(
                    'Emily',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Age: 24',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Joined since 21 Oct 2023',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'UK • London',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'A passionate marketing specialist with a flair for creativity and innovation.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 10),
                  const Text(
                    'Listened a moment ago',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  _buildMusicTile('Waves of Stardust', 'Midnight Echoes', 'assets/music_cover.jpg'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildChip('Liked Artists'),
                      _buildChip('Liked Tracks'),
                      _buildChip('Liked Genres'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildMusicTile('Echoes in the Dark', 'Midnight Echoes', 'assets/music_cover2.jpg'),
                  _buildMusicTile('Mosaic of Memories', 'Infinity Sound', 'assets/music_cover3.jpg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicTile(String title, String artist, String image) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(artist, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.bookmark_border, color: Colors.white),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.white24,
    );
  }
}
