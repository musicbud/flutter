import 'dart:ui';

import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: const Color.fromARGB(54, 0, 0, 0),
      body: Stack(
        children: [
          // Main content with gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 255, 254, 254),
                  //Color.fromARGB(255, 128, 116, 116),

                  // Color.fromARGB(255, 32, 85, 150),
                  // Color.fromARGB(255, 91, 27, 83),
                  // Color.fromARGB(255, 180, 248, 32),
                  Color.fromARGB(255, 170, 195, 199),
                  // Color.fromARGB(255, 91, 27, 83),
                  // Color.fromARGB(255, 243, 169, 169),
                  // Color.fromARGB(255, 32, 85, 150),
                  // Color.fromARGB(255, 246, 171, 236),
                  // Color.fromARGB(255, 43, 15, 15),
                  Color.fromARGB(255, 255, 255, 255),

                ],
              ),
            ),

            // custom App Bar
            child: Column(
              children: [
                //CustomAppBar(),
                
                    //Add your main content here
                    const Expanded(
                      child: Center(
                        child: Text('Main Content Area'),
                      ),
                        ),
              ],
            ),
          ),

          // Bottom Navigation Bar positioned at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.srcOver,
                color: const Color(0x793B3B3B),
                border: Border.all(
                    width: .2, color: Colors.grey,),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
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
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: const Color(0x793B3B3B),
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFFF6B8F),
            radius: 25,
            child: Center(
              child: Icon(
                Icons.person_pin,
                color: Theme.of(context).colorScheme.onSecondary,
                //const Color(0xFF232C4E),
                size: 40,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Home',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}








