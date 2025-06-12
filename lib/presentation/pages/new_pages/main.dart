import 'package:flutter/material.dart';

import 'profile_card.dart';

void main(List<String> args) {
  runApp(ProfileApp(key: UniqueKey()));
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreenCard(key: UniqueKey()),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/cover.jpg'), // Cover image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 20,
                    child: CircleAvatar(
                      radius: 90,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Abd ElRahman',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Age: 33',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Joined since 25 Jan 2011',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white70),
                      SizedBox(width: 5),
                      Text(
                        'UK • London Eldoor elTany',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'A passionate marketing specialist with a flair for creativity and innovation.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overview',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Library',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Playlist',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'following',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'followers',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Divider(thickness: 3, color: Colors.white24),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.music_note_outlined, color: Colors.white70),
                      SizedBox(width: 5),
                      Text(
                        'Listened a moment ago',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/music_cover3.jpg'),
                        fit: BoxFit.cover,
                      ),
                      color: const Color.fromARGB(23, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _buildMusicTile('Waves of Stardust',
                        'Midnight Echoes', 'assets/music_cover3.jpg'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.share, color: Colors.white70),
                      SizedBox(width: 5),
                      Text(
                        'You share in common',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildChip('Liked Artists'),
                      _buildChip('Liked Tracks'),
                      _buildChip('Liked Genres'),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildMusicTile('Echoes in the Dark', 'Midnight Echoes',
                      'assets/music_cover2.jpg'),
                  _buildMusicTile('Mosaic of Memories', 'Infinity Sound',
                      'assets/music_cover.jpg'),
                ],
              ),
            ),Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.srcOver,
                color: const Color.fromARGB(121, 59, 59, 59),
                border: Border.all(
                    width: .5, color: const Color.fromARGB(255, 199, 7, 7)),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: const Color.fromARGB(2, 0, 0, 0),
                  elevation: 0,
                  selectedItemColor: const Color(0xFFFF6B8F),
                  unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.laptop_mac_outlined),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.headphones),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_rounded),
                      label: '',
                    ),
                  ],
                ),
              ),
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
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(artist, style: TextStyle(color: Colors.white70)),
      trailing: Icon(Icons.bookmark_border, color: Colors.white),
    );
  }

  Widget _buildChip(
    String label,
  ) {
    return Chip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}










// import 'dart:ui';

// import 'package:flutter/material.dart';


// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark(),
//       home: const HomeScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(54, 0, 0, 0),
//       body: Stack(
//         children: [
//           // Main content with gradient background
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color.fromARGB(255, 63, 60, 60),
//                   Color.fromARGB(255, 32, 85, 150),
//                   Color.fromARGB(255, 91, 27, 83),
//                   Color.fromARGB(255, 180, 248, 32),
//                   Color.fromARGB(255, 32, 85, 150),
//                   Color.fromARGB(255, 91, 27, 83),
//                   Color.fromARGB(255, 243, 169, 169),
//                   Color.fromARGB(255, 32, 85, 150),
//                   Color.fromARGB(255, 246, 171, 236),
//                   Color.fromARGB(255, 43, 15, 15),
//                   Color.fromARGB(255, 255, 255, 255),
//                 ],
//               ),
//             ),
//             child: SafeArea(
//               child: Column(
//                 children: [
//                   // Custom App Bar
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: const Color(0xFFFF6B8F),
//                           radius: 20,
//                           child: Center(
//                             child: Icon(
//                               Icons.person_off_outlined,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         const Text(
//                           'Home',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const Spacer(),
//                         IconButton(
//                           icon: const Icon(Icons.settings),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Add your main content here
//                   const Expanded(
//                     child: Center(
//                       child: Text('Main Content Area'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Bottom Navigation Bar positioned at the bottom
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               height: 80,
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
//               decoration: BoxDecoration(
//                 backgroundBlendMode: BlendMode.srcOver,
//                 color: const Color.fromARGB(121, 59, 59, 59),
//                 border: Border.all(
//                     width: .5, color: const Color.fromARGB(255, 199, 7, 7)),
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(25),
//                 child: BottomNavigationBar(
//                   currentIndex: _selectedIndex,
//                   onTap: (index) {
//                     setState(() {
//                       _selectedIndex = index;
//                     });
//                   },
//                   type: BottomNavigationBarType.fixed,
//                   backgroundColor: const Color.fromARGB(2, 0, 0, 0),
//                   elevation: 0,
//                   selectedItemColor: const Color(0xFFFF6B8F),
//                   unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
//                   items: const [
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.laptop_mac_outlined),
//                       label: '',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.search),
//                       label: '',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.headphones),
//                       label: '',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.chat_rounded),
//                       label: '',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark(),
//       home: const HomeScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 194, 187, 231),
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color.fromARGB(255, 103, 99, 99),
//                   Color.fromARGB(255, 158, 146, 146),
//                 ],
//               ),
//             ),
//             child: SafeArea(
//               child: Column(
//                 children: [
//                   // Custom App Bar
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       children: [
//                         const CircleAvatar(
//                           backgroundColor: Color(0xFFFF6B8F),
//                           radius: 20,
//                         ),
//                         const Spacer(),
//                         const Text(
//                             'Home',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.underline,
//                               decorationColor: Colors.blue,
//                               decorationThickness: 2,
//                             ),
//                           ),  
//                         const Spacer(),
//                         IconButton(
//                           icon: const Icon(Icons.settings),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ),
                  
//                   // Add your main content here
          
//                   const Expanded(
//                     child: Center(
//                       child: Text('Main Content Area'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Positioned(
//         left: 0,  
//         right: 0,
//         bottom: 0,
//         top: 0,
//         child: Container(
//           height: 65,
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1A1A1A),
//             borderRadius: const BorderRadius.all(Radius.circular(20)),
          
//             boxShadow: [
//               BoxShadow(
//                 color: const Color.fromARGB(255, 31, 174, 2).withOpacity(0.3),
//                 blurRadius: 25,
//               ),
//             ],
//            ),
//           child: ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(15), bottom: Radius.circular(15)),
//             child: BottomNavigationBar(
//               currentIndex: _selectedIndex,
//               onTap: (index) {
//                 setState(() {
//                   _selectedIndex = index;
//                 });
//               },
//               type: BottomNavigationBarType.fixed,
//               backgroundColor: const Color.fromARGB(0, 205, 41, 41),
//               elevation: 0,
//               selectedItemColor: const Color(0xFFFF6B8F),
//               unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.laptop_mac),
//                   label: '',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.search),
//                   label: '',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.notifications_outlined),
//                   label: '',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.chat_bubble_outline),
//                   label: '',
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }