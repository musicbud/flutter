import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> users = [
      User("Liam Carter", "See what they're listening to", true, 'assets/profile.jpg'),
      User("Ava Sinclair", "You: Alright!", false, 'assets/profile2.jpg'),
      User("Noah Bennett", "You: what you doing lately", false, 'assets/profile6.jpg'),
      User("Ethan Reed", "😂😂😂😂", false, 'assets/white_card.jpg'),
      User("Mia Thompson", "See what they're listening to", false, 'assets/music_cover2.jpg'),
      User ("Zoe Patel", "Hope we meet again 💙💙", false, 'assets/cover.jpg'),
      User ("Sia Patel", "Hope we meet again 💙💙", true, 'assets/cover2.jpg'),
      User ("Patel jack", "Hope we meet again", false, 'assets/cover4.jpg'),
    ];

    final List<MusicGenre> genres = [
      MusicGenre("Melodic Fusion", 'assets/cover.jpg'),
      MusicGenre("Bassline Society", 'assets/cover2.jpg'),
      MusicGenre("Echo Chamber", 'assets/cover3.jpg'),
      MusicGenre("Sound Collective", 'assets/cover4.jpg'),

      MusicGenre("Melodic Fusion", 'assets/cover.jpg'),
      MusicGenre("Bassline Society", 'assets/cover6.jpg'),
      MusicGenre("Echo Chamber", 'assets/music_cover4.jpg'),
      MusicGenre("Sound Collective", 'assets/profile2.jpg'),

      MusicGenre("Melodic Fusion", 'assets/profile4.jpg'),
      MusicGenre("Bassline Society", 'assets/cover2.jpg'),
      MusicGenre("Echo Chamber", 'assets/music_cover6.jpg'),
      MusicGenre("Sound Collective", 'assets/music_cover7.jpg'),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pixiled_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Chats List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ChatTile(user: users[index]);
                  },
                ),
              ),
            ),
            // Scrollable Row of Music Genres
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  return GenreCard(genre: genres[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Chat Item Widget
class ChatTile extends StatelessWidget {
  final User user;
  const ChatTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            backgroundColor: Colors.pinkAccent,
            radius: 24,
            child: ClipOval(child: Image.asset(user.imageUrl, fit: BoxFit.cover, width: 48, height: 48,)),
          ),
          const SizedBox(width: 12),

          // Name and Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.status,
                  style: TextStyle(
                    color: user.isSpecial ? Colors.pinkAccent : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Match Now Button
          MatchNowButton(isHighlighted: user.isSpecial),
        ],
      ),
    );
  }
}

// "Match Now" Button Widget
class MatchNowButton extends StatelessWidget {
  final bool isHighlighted;
  const MatchNowButton({super.key, required this.isHighlighted});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isHighlighted) ...[
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.pinkAccent,
                      child: ClipOval(child: Image.asset('assets/profile.jpg', fit: BoxFit.cover, width: 24, height: 24)),
                    ),
                    Positioned(
                      left: 15,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.pinkAccent,
                        child: ClipOval(child: Image.asset('assets/profile4.jpg', fit: BoxFit.cover, width: 24, height: 24)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
              ],
              const Text(
                "Match now",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Music Genre Card Widget
class GenreCard extends StatelessWidget {
  final MusicGenre genre;
  const GenreCard({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ClipOval(
            child: Image.asset(genre.imageUrl, fit: BoxFit.cover, width: 80, height: 80),
          ),
          const SizedBox(height: 6),
          Text(
            genre.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Models
class User {
  final String name;
  final String status;
  final bool isSpecial;
  final String imageUrl;
  User(this.name, this.status, this.isSpecial, this.imageUrl);
}

class MusicGenre {
  final String name;
  final String imageUrl;

  MusicGenre(this.name, this.imageUrl);
}





//////////////////////////////////////////////////////////////////////////////
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const ChatListScreen(),
//     );
//   }
// }

// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<User> users = [
//       User("Liam Carter", "See what they're listening to", true),
//       User("Ava Sinclair", "You: Alright!", false),
//       User("Noah Bennett", "You: what you doing lately", false),
//       User("Ethan Reed", "😂😂😂😂", false),
//       User("Mia Thompson", "See what they're listening to", false),
//       User("Zoe Patel", "Hope we meet again 💙💙", false),
//     ];

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/pixiled_background.jpg'), fit: BoxFit.cover,)),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   return ChatTile(user: users[index]);
//                 },
//               ),
//             ),


//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatTile extends StatelessWidget {
//   final User user;
//   const ChatTile({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           // Profile Image
//           CircleAvatar(
//             backgroundColor: Colors.pinkAccent,
//             radius: 24,
//             child: ClipOval(child: Image.asset('assets/profile6.jpg' , fit: BoxFit.fill, width: 48, height: 48,)),
//           ),
//           const SizedBox(width: 12),

//           // Name and Status
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   user.name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   user.status,
//                   style: TextStyle(
//                     color: user.isSpecial ? Colors.pinkAccent : Colors.grey,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],

//             ),
//           ),

//           // Match Now Button
//           MatchNowButton(isHighlighted: user.isSpecial),
//         ],
//       ),

//     );
//   }
// }

// // "Match Now" Button Widget
// class MatchNowButton extends StatelessWidget {
//   final bool isHighlighted;
//   const MatchNowButton({super.key, required this.isHighlighted});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(

//             color: Colors.white,
//             borderRadius: BorderRadius.circular(50),
//           ),
//           child: SingleChildScrollView(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (isHighlighted) ...[
//                   Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       CircleAvatar(
//                         radius: 13,
//                         backgroundColor: Colors.pinkAccent,
//                         child: ClipOval(child: Image.asset('assets/profile.jpg', fit: BoxFit.cover, width: 24, height: 24,)),// Replace with your desired color 0xFF232C4E),
//                       ),
//                       Positioned(
//                         left: 15,
//                         child: CircleAvatar(
//                           radius: 13,
//                           backgroundColor: Colors.pinkAccent,

//                            child: ClipOval(child: Image.asset('assets/profile4.jpg', fit: BoxFit.cover, width: 24, height: 24,)),// Replace with your desired color 0xFF232C4E
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 16),
//                 ],
//                 const Text(
//                   "Match now",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 const Icon(
//                   Icons.arrow_forward_ios,
//                   size: 14,
//                   color: Colors.black,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],

//     );
//   }
// }

// // User Model
// class User {
//   final String name;
//   final String status;
//   final bool isSpecial;

//   User(this.name, this.status, this.isSpecial);
// }





////////////////////////////////////////////////////////////////////////////////////

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MaterialApp(home: ChatScreen(

//   )));
// }

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(backgroundColor: Color(0xFF232C4E),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: CircleAvatar(
//                     radius: 30,
//                     backgroundImage: AssetImage('assets/profile.jpg'),
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     Text(
//                       'Liam Carter',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.normal,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       'Online now 🤔🤔??',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Spacer(),
//                 MatchNowButton(),

//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MatchNowButton extends StatelessWidget {
//   const MatchNowButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(50),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(2, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               CircleAvatar(
//                 radius: 12,
//                 backgroundColor: Colors.white,
//                 child: ClipOval(
//                   child: Image.asset( 'assets/profile4.jpg', width: 24, height: 24, fit: BoxFit.cover,)
//                 ),
//               ),
//               Positioned(
//                 left: 18, // Adjust overlap
//                 child: CircleAvatar(
//                   radius: 12,
//                   backgroundColor: Colors.white,
//                   child: ClipOval(
//                     child: Image.asset( 'assets/profile2.jpg', width: 24, height: 24, fit: BoxFit.cover,)
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 16),
//           const Text(
//             "Match now",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(width: 6),
//           const Icon(
//             Icons.arrow_forward_ios,
//             size: 14,
//             color: Colors.black,
//           ),
//         ],
//       ),
//     );
//   }
// }

