import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CardsScreen(),
    );
  }
}

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Row(
                children: [
                  InfoText(title: 'Listeners', value: '45.2k'),
                  SizedBox(width: 20),
                  InfoText(title: 'Scrobbles', value: '345.5k'),
                  Spacer(),
                  Icon(Icons.equalizer_rounded, color: Colors.white),
                  SizedBox(width: 10),
                  Icon(Icons.bookmark_border, color: Colors.white),
                ],
              ),
              const SizedBox(height: 20),
              const MusicCard(),
              const SizedBox(height: 20),
              const DetailText(
                title: 'Length:',
                highlight: true,
                value: '                  3:24',
                maxLines: 1,
              ),
              const DetailText(
                title: 'Lyrics:',
                value:
                    '''                    In the shadows where the whispers play, 
                    Stars are dancing, guiding my way. Lost in the...''',
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Tags:',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(width: 110),
                    Wrap(
                      spacing: 20,
                      children: [
                        'Ambient',
                        'Dreamy',
                        'Soundscape',
                        'Relaxation',
                        'Chill',
                        'Meditation',
                        'Calm'
                      ].map((tag) => Chip(label: Text(tag))).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('External Links',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const ExternalLink(icon: Icons.music_note, text: 'Spotify'),
              const ExternalLink(icon: Icons.play_circle_fill, text: 'Youtube Music'),
              const ExternalLink(icon: Icons.camera_alt, text: 'Instagram'),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  final String title;
  final String value;

  const InfoText({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class MusicCard extends StatelessWidget {
  const MusicCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Stack(
        children: [
          Container(
            height: 420,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/music_cover3.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[900],
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 10),
                const Text('Stars in the Dust',
                    style: TextStyle(color: Colors.white, fontSize: 35)),
                const Text('The Celestial Nomads',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                const Text(
                  """is an ethereal blend of ambient and acoustic soundscapes that transports listeners to a serene, celestial realm. The track opens with a gentle, melodic guitar riff that sets the tone for the rest of the song. music is perfect for meditation, relaxation, or simply getting lost in the beauty of the cosmos.""",
                  style: TextStyle(color: Colors.white70),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildMusicTile("Waves of Stardust", "Midnight Echoes",
                    'assets/music_cover2.jpg'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Positioned(
            bottom: 0,
            right: 10,
            child: Icon(Icons.play_circle_outline_outlined,
                color: Colors.white, size: 80),
          ),
        ],
      ),
    );
  }
}

class DetailText extends StatelessWidget {
  final String title;
  final String value;
  final bool highlight;

  const DetailText(
      {super.key, required this.title,
      required this.value,
      this.highlight = false,
      required int maxLines});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(width: 30),
        Text(value,
            style: TextStyle(
                color: highlight ? Colors.redAccent : Colors.white70)),
      ],
    );
  }
}

class ExternalLink extends StatelessWidget {
  final IconData icon;
  final String text;

  const ExternalLink({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 20),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

Widget _buildMusicTile(String title, String artist, String image) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(98, 43, 43, 43),
        border: Border.all(
            color: const Color.fromARGB(255, 123, 122, 122), width: .3)),
    child: ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(artist, style: const TextStyle(color: Colors.white70)),
    ),
  );
}
