import 'package:flutter/material.dart';

class StoriesPage extends StatelessWidget {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF3E4C33), // Dark green background
            child: const Text(
              'Stories',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Main content
          Expanded(
            child: Stack(
              children: [
                // Map background
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF1a1a2e), // Dark blue background instead of image
                    // image: DecorationImage(
                    //   image: AssetImage('assets/dark_map_bg.jpg'),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),

                // Top bar with title and camera button
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // User avatar
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24),
                            color: Colors.blue, // Placeholder color instead of image
                            // image: const DecorationImage(
                            //   image: AssetImage('assets/user_avatar.jpg'),
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),

                        // Title
                        const Text(
                          'Stories',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Camera button
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Story circles at the top
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        _buildStoryCircle('You', 'assets/user_avatar.jpg', isYou: true),
                        _buildStoryCircle('Ali ahmed', 'assets/ali_avatar.jpg'),
                        _buildStoryCircle('Mohammed', 'assets/mohammed_avatar.jpg'),
                        _buildStoryCircle('Ahmed', 'assets/ahmed_avatar.jpg'),
                        _buildStoryCircle('Ahmed', 'assets/ahmed2_avatar.jpg'),
                      ],
                    ),
                  ),
                ),

                // Map story pins
                Positioned(
                  left: 110,
                  top: 230,
                  child: _buildMapPin('Ali ahmed', 'assets/ali_avatar.jpg', 2, showDetails: true),
                ),

                Positioned(
                  right: 30,
                  bottom: 120,
                  child: _buildMapPin('Ahmed', 'assets/ahmed_avatar.jpg', 1),
                ),

                Positioned(
                  right: 120,
                  top: 350,
                  child: _buildMapPin('Mohammed', 'assets/mohammed_avatar.jpg', 4),
                ),

                // Bottom navigation bar
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavButton(Icons.lightbulb_outline, isSelected: true),
                        _buildNavButton(Icons.search),
                        _buildNavButton(Icons.headphones),
                        _buildNavButton(Icons.chat_bubble_outline),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCircle(String name, String imagePath, {bool isYou = false}) {
    return Container(
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isYou ? Colors.blue : Colors.pink,
                    width: 2,
                  ),
                  color: isYou ? Colors.blue : Colors.purple, // Placeholder color instead of image
                  // image: DecorationImage(
                  //   image: AssetImage(imagePath),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              if (isYou)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(String name, String imagePath, int count, {bool showDetails = false}) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.pink,
                  width: 2,
                ),
                color: Colors.orange, // Placeholder color instead of image
                // image: DecorationImage(
                //   image: AssetImage(imagePath),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 25,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        if (showDetails)
          Container(
            width: 150,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                const Text(
                  'Ali ahmed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Location
                Row(
                  children: const [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: Colors.white70,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Egypt · Al sharqia',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Dreamcatcher badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.yellow],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dreamcatcher',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Priority: Second',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNavButton(IconData icon, {bool isSelected = false}) {
    return Container(
      width: 64,
      height: 40,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: Colors.pink, width: 1)
            : null,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.pink : Colors.white70,
        size: 22,
      ),
    );
  }
}