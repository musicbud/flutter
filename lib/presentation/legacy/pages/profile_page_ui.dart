import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: () {
              Navigator.pushNamed(context, '/profile'); // Or Navigator.push
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildUserInfo(),
            _buildMusicActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/header_image.jpg'), // Replace with actual image
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/profile_image.jpg'), // Replace with actual image
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Emily", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("Age: 24", style: TextStyle(color: Colors.grey)),
          const Text("Joined since 21 Oct 2023", style: TextStyle(color: Colors.grey)),
          const Text("Joined since 21 Oct 2023", style: TextStyle(color: Colors.grey)),
          const Text("\u{1F30D} UK - London", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          const Text(
            "A passionate marketing specialist with a flair for creativity and innovation. With over five years of experience in digital marketing.",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tabButton("Overview"),
              _tabButton("Library"),
              _tabButton("Playlist"),
              _tabButton("Following"),
              _tabButton("Followers"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMusicActivity() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("\u{1F3B5} Listened a moment ago", style: TextStyle(color: Colors.grey)),
          const  SizedBox(height: 8),
          _musicCard("Waves of Stardust", "Midnight Echoes", "assets/music_cover.jpg"),
          const SizedBox(height: 16),
          const Text("You share in common", style: TextStyle(color: Colors.white, fontSize: 18)),
          Row(
            children: [
              _filterButton("Liked Artists"),
              _filterButton("Liked tracks"),
              _filterButton("Liked Genres"),
            ],
          ),
          const SizedBox(height: 8),
          _musicCard("Echoes in the Dark", "Midnight Echoes", "assets/music_cover2.jpg"),
          _musicCard("Mosaic of Memories", "Infinity Sound", "assets/music_cover3.jpg"),
        ],
      ),
    );
  }

  Widget _musicCard(String title, String artist, String imagePath) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        leading: Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(artist, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.bookmark_border, color: Colors.white),
      ),
    );
  }

  Widget _tabButton(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(text, style: const TextStyle(color: Colors.white70)),
    );
  }

  Widget _filterButton(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {},
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
