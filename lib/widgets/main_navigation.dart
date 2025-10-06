import 'package:flutter/material.dart';
import '../utils/logger.dart';

class MainNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('Building MainNavigation with currentIndex: $currentIndex');
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        logger.d('Bottom navigation item tapped: $index');
        onTap(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}