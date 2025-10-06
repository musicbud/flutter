import 'package:flutter/material.dart';
import 'main_navigation.dart';
import '../utils/logger.dart';

class MainNavigationScaffold extends StatefulWidget {
  final Widget body;
  final int initialIndex;

  const MainNavigationScaffold({
    Key? key,
    required this.body,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _MainNavigationScaffoldState createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    logger.d('MainNavigationScaffold initialized with initialIndex: ${widget.initialIndex}');
  }

  void _onTap(int index) {
    logger.d('Navigation item tapped in MainNavigationScaffold: $index');
    setState(() {
      _currentIndex = index;
    });
    logger.d('Navigation index changed to: $_currentIndex');
    // Handle navigation logic here
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Building MainNavigationScaffold with currentIndex: $_currentIndex');
    return Scaffold(
      body: widget.body,
      bottomNavigationBar: MainNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}