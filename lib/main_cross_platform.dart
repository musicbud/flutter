import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core imports
import 'data/providers/cross_platform_token_provider.dart';
import 'core/theme/design_system.dart';

void main() {
  runApp(const MusicBudCrossPlatformApp());
}

class MusicBudCrossPlatformApp extends StatelessWidget {
  const MusicBudCrossPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CrossPlatformTokenProvider>(
          create: (_) => CrossPlatformTokenProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'MusicBud',
        debugShowCheckedModeBanner: false,
        theme: DesignSystem.lightTheme,
        darkTheme: DesignSystem.darkTheme,
        themeMode: ThemeMode.system,
        home: const AppInitializer(),
        routes: {
          '/login': (context) => const SimpleLoginScreen(),
          '/home': (context) => const SimpleHomeScreen(),
        },
        onGenerateRoute: (settings) {
          // Handle unknown routes
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Page Not Found')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64),
                    const SizedBox(height: 16),
                    Text('Route ${settings.name} not found'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                      child: const Text('Go Home'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SimpleHomeScreen extends StatefulWidget {
  const SimpleHomeScreen({super.key});

  @override
  State<SimpleHomeScreen> createState() => _SimpleHomeScreenState();
}

class _SimpleHomeScreenState extends State<SimpleHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MusicBud'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final tokenProvider = Provider.of<CrossPlatformTokenProvider>(context, listen: false);
              await tokenProvider.clearTokens();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          _buildDiscoverContent(),
          _buildProfileContent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Discover new music and connect with friends'),
                  const SizedBox(height: 16),
                  Consumer<CrossPlatformTokenProvider>(
                    builder: (context, tokenProvider, child) {
                      return Text(
                        'Storage: ${tokenProvider.storageType}',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildQuickActionCard(
                  icon: Icons.search,
                  title: 'Search',
                  subtitle: 'Find music and artists',
                  onTap: () => _showNotImplemented(context),
                ),
                _buildQuickActionCard(
                  icon: Icons.library_music,
                  title: 'My Library',
                  subtitle: 'Your saved music',
                  onTap: () => _showNotImplemented(context),
                ),
                _buildQuickActionCard(
                  icon: Icons.people,
                  title: 'Find Buds',
                  subtitle: 'Connect with friends',
                  onTap: () => _showNotImplemented(context),
                ),
                _buildQuickActionCard(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'App preferences',
                  onTap: () => _showNotImplemented(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoverContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore, size: 64),
          SizedBox(height: 16),
          Text(
            'Discover Music',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Find new music and artists'),
          SizedBox(height: 16),
          Text(
            'Feature not yet implemented in this demo',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.person, size: 32, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Demo User',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text('demo@musicbud.com'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Storage Type'),
              subtitle: Consumer<CrossPlatformTokenProvider>(
                builder: (context, tokenProvider, child) {
                  return Text(tokenProvider.storageType);
                },
              ),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('App Version'),
              subtitle: Text('1.0.0 (Cross-Platform Demo)'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                final tokenProvider = Provider.of<CrossPlatformTokenProvider>(context, listen: false);
                await tokenProvider.clearTokens();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showNotImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is not yet implemented in the demo'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitializing = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Add a small delay to show the splash screen
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Check login status
      final tokenProvider = Provider.of<CrossPlatformTokenProvider>(context, listen: false);
      final hasTokens = await tokenProvider.hasTokens();
      final isLoggedIn = await tokenProvider.isLoggedIn();
      
      setState(() {
        _isLoggedIn = hasTokens && isLoggedIn;
        _isInitializing = false;
      });
    } catch (e) {
      // If initialization fails, just go to login
      setState(() {
        _isLoggedIn = false;
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const SplashScreen();
    }
    
    return _isLoggedIn ? const SimpleHomeScreen() : const SimpleLoginScreen();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo/icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note,
                size: 60,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'MusicBud',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Connect through music',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Consumer<CrossPlatformTokenProvider>(
              builder: (context, tokenProvider, child) {
                return Text(
                  'Storage: ${tokenProvider.storageType}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleLoginScreen extends StatefulWidget {
  const SimpleLoginScreen({super.key});

  @override
  State<SimpleLoginScreen> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate login for demonstration
      await Future.delayed(const Duration(seconds: 2));
      
      final tokenProvider = Provider.of<CrossPlatformTokenProvider>(context, listen: false);
      await tokenProvider.updateTokens('demo_access_token', 'demo_refresh_token');
      await tokenProvider.setLoggedIn(true);
      await tokenProvider.setUserId('demo_user_id');

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.music_note,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome to MusicBud',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connect through music',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),
              // Login form
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Consumer<CrossPlatformTokenProvider>(
                builder: (context, tokenProvider, child) {
                  return Text(
                    'Storage: ${tokenProvider.storageType}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}