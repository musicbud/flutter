import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatelessWidget {
  final List<Map<String, String>> songs = [
    {'title': 'Dancing Shadows', 'subtitle': 'Popular Artists', 'image': 'assets/song1.png'},
    {'title': 'Electric Serenade', 'subtitle': 'Featured Artists', 'image': 'assets/song2.png'},
    {'title': 'Beyond the Horizon', 'subtitle': 'Astral Echo', 'image': 'assets/song3.png'},
    {'title': "Serenity's Call", 'subtitle': 'Sapphire Moon', 'image': 'assets/song4.png'},
  ];

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            SearchBar(icon: Icons.search_sharp, hint: '            What do you want to listen to ?', ), 
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return SongItem(
                    title: song['title']!,
                    subtitle: song['subtitle']!,
                    //image: song['image']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final IconData icon;
  final String hint;

  const SearchBar({super.key, required this.icon, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(82, 137, 141, 178),
        border: Border.all(color: const Color(0xFFCFD0FD)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(icon, color: const Color(0xFFCFD0FD)),
          SizedBox(width: 10),
          Expanded(
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: const Color(0xFFCFD0FD),
                    fontFamily: 'JosefinSans',
                  ),
                ),
                style: TextStyle(
                  color: const Color(0xFFCFD0FD),
                  fontSize: 18,
                  fontFamily: 'JosefinSans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SongItem extends StatelessWidget {
  final String title;
  final String subtitle;
//  final String image;

  const SongItem({super.key, required this.title, required this.subtitle, 
  //required this.image
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset("assets/cover.jpg", width: 50, height: 50, fit: BoxFit.cover),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'JosefinSans',
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: const Color.fromARGB(153, 207, 208, 253),
                  fontSize: 14,
                  fontFamily: 'JosefinSans',
                ),
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.close, color: const Color(0xFFCFD0FD)),
        ],
      ),
    );
  }
}
