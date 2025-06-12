import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'josefin_sans',
        brightness: Brightness.dark,
      ),
      home: const EventDetailsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/black_speckled_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Festival Title
                  const Text(
                    'Annual Harmony Music Festival!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Subtitle with featured artists
                  const Text(
                    'Featuring Midnight Echoes, Sapphire Moon and 42 more artists at Harmony Heights Festival',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action buttons
                  Row(
                    children: [
                      Spacer(),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(maxLines: 1,
                          "I'm going",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Spacer(),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(maxLines: 1,
                          "I'm interested",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Date section
                  _buildSectionWithIcon(
                    icon: Icons.calendar_today,
                    title: 'Date',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Wednesday, 14 May, 2025',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Location section
                  _buildSectionWithIcon(
                    icon: Icons.location_on,
                    title: 'Location',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Harmony Heights Festival, Banff National Park, Alberta, Canada, T1L 1B8 | Phone: (555) 012-3456 | Date: July 15-17, 2025',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 20),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Show in map',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Attendance section
                  Row(
                    children: [
                      const Icon(Icons.people, color: Colors.white70, size: 20),
                      const SizedBox(width: 12),
                      const Text(
                        'Attendance',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward, color: Colors.white70),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Attendance info with buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              '32 going',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              '4 interested',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Attendee profiles
                  SingleChildScrollView(scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAttendeeProfile('Sophie', 'assets/profile.jpg'),
                        _buildAttendeeProfile('Ethan Caldwell', 'assets/profile2.jpg'),
                        _buildAttendeeProfile('Clara Bennett', 'assets/cover.jpg'),
                        _buildAttendeeProfile('Maxwell Trent', 'assets/cover2.jpg'),
                        _buildAttendeeProfile('Lucas Hawthorne', 'assets/cover3.jpg'),
                        _buildAttendeeProfile('Sophie', 'assets/profile.jpg'),
                        _buildAttendeeProfile('Ethan Caldwell', 'assets/profile2.jpg'),
                        _buildAttendeeProfile('Clara Bennett', 'assets/cover.jpg'),
                        _buildAttendeeProfile('Maxwell Trent', 'assets/cover2.jpg'),
                        _buildAttendeeProfile('Lucas Hawthorne', 'assets/cover3.jpg'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description section
                  Row(
                    children: [
                      const Icon(Icons.description, color: Colors.white70, size: 20),
                      const SizedBox(width: 12),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward, color: Colors.white70),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description content
                  const Text(
                    'Join us at the Harmony Heights Festival, nestled in the breathtaking Banff National Park! Experience three days of unforgettable music featuring top artists across various genres, from indie rock to electronic beats. Enjoy local food vendors, artisan markets, and breathtaking mountain views. With wellness workshops, late-night bonfires, and activities for all ages, this festival is a celebration of music and nature. Don\'t miss the chance to create lasting memories in the heart of the Canadian Rockies!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // New font info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Colors.black54,
                    child: const Text(
                      'New available font: josefin sans',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionWithIcon({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              content,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendeeProfile(String name, String imagePath) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(imagePath),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 65,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
