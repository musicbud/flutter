import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreenCard(),
    );
  }
}

class ProfileScreenCard extends StatelessWidget {
  const ProfileScreenCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pixiled_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              AvatarNotifications(),
              SizedBox(height: 20),
              ProfileCard(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarNotifications extends StatelessWidget {
  const AvatarNotifications({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              height: 65,
              width: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFB48080), width: 1.1),
              ),
              child: CircleAvatar(
                backgroundColor: Color(0xFFB48080),
                radius: 55,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
            ),
            Positioned(
              top: 5,
              right: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF265A),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '9',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
        Icon(Icons.arrow_drop_down, color: const Color(0xFFB48080), size: 14),

        //ProfileCard(),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 102,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Color.fromARGB(145, 15, 15, 19),
          border: Border.all(color: const Color(0xFFCFD0FD), width: .1)),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 6, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ali Ahmed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(size: 10, Icons.location_on_outlined, color: const Color(0xFFCFD0FD)),
                SizedBox(width: 5),
                Text(
                  'Egypt - Al Sharqia',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFFCFD0FD)),
                ),
              ],
            ),
            SizedBox(height: 12),
            // _buildMusicTile('Echoes in the Dark', 'Midnight Echoes',
            //     'assets/music_cover2.jpg'),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: .3,
                      color: const Color(0x4FC5C5C5)),
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                children: [
                  Spacer(),
                  Container(
                    width: 23,
                    height: 23,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(0, 197, 197, 197)),
                        borderRadius: BorderRadius.circular(4)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset('assets/music_cover.jpg',
                          fit: BoxFit.fill),
                    ),
                    //Image.asset("assets/music_cover.jpg", fit: BoxFit.fitHeight,),
                  ),
                  SizedBox(width: 5),
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('Echoes in the Dark',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                    Text('Midnight Echoes',
                        style: TextStyle(color: const Color(0xFFCFD0FD), fontSize: 9)),
                  ]),
                  Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


