import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/spotify/spotify_bloc.dart';
import '../../../blocs/auth/ytmusic/ytmusic_bloc.dart';
import '../../../blocs/auth/lastfm/lastfm_bloc.dart';
import '../../../blocs/auth/mal/mal_bloc.dart';
import '../../../blocs/services/services_bloc.dart';
import '../../../domain/models/content_service.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class ServiceConnectionPage extends StatefulWidget {
  const ServiceConnectionPage({Key? key}) : super(key: key);

  @override
  State<ServiceConnectionPage> createState() => _ServiceConnectionPageState();
}

class _ServiceConnectionPageState extends State<ServiceConnectionPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, TextEditingController> _authControllers = {
    'spotify': TextEditingController(),
    'ytmusic': TextEditingController(),
    'lastfm': TextEditingController(),
    'mal': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    // Load connected services
    _loadConnectedServices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _authControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _loadConnectedServices() {
    // TODO: Load services
    print('Loading services...');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Connect Services',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConnectedServices,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildConnectedServicesOverview(),
          _buildTabBar(),
          Expanded(
            child: _buildTabView(),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedServicesOverview() {
    // TODO: Implement services overview
    return const SizedBox.shrink();
  }

  Widget _buildServicesOverview(List<ContentService> services) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connected Services',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: services.map((service) => _buildServiceChip(service)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(ContentService service) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: _getServiceColor(service.name).withOpacity(0.2),
        child: Icon(
          _getServiceIcon(service.name),
          color: _getServiceColor(service.name),
          size: 16,
        ),
      ),
      label: Text(
        service.name,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: AppConstants.surfaceColor,
      side: BorderSide(
        color: _getServiceColor(service.name),
        width: 2,
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.textSecondaryColor,
        tabs: const [
          Tab(text: 'Spotify'),
          Tab(text: 'YouTube Music'),
          Tab(text: 'LastFM'),
          Tab(text: 'MAL'),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildSpotifyTab(),
        _buildYTMusicTab(),
        _buildLastFMTab(),
        _buildMALTab(),
      ],
    );
  }

  Widget _buildSpotifyTab() {
    // TODO: Implement Spotify tab
    return _buildServiceTab(
      'Spotify',
      Icons.music_note,
      Colors.green,
      'Connect your Spotify account to sync your music library, playlists, and listening history.',
      null,
      () => _connectSpotify(),
      () => _disconnectSpotify(),
      () => _getSpotifyAuthUrl(),
    );
  }

  Widget _buildYTMusicTab() {
    // TODO: Implement YouTube Music tab
    return _buildServiceTab(
      'YouTube Music',
      Icons.play_circle_filled,
      Colors.red,
      'Connect your YouTube Music account to sync your music library and playlists.',
      null,
      () => _connectYTMusic(),
      () => _disconnectYTMusic(),
      () => _getYTMusicAuthUrl(),
    );
  }

  Widget _buildLastFMTab() {
    // TODO: Implement LastFM tab
    return _buildServiceTab(
      'LastFM',
      Icons.radio,
      Colors.purple,
      'Connect your LastFM account to track your listening habits and discover new music.',
      null,
      () => _connectLastFM(),
      () => _disconnectLastFM(),
      () => _getLastFMAuthUrl(),
    );
  }

  Widget _buildMALTab() {
    // TODO: Implement MAL tab
    return _buildServiceTab(
      'MyAnimeList',
      Icons.animation,
      Colors.blue,
      'Connect your MyAnimeList account to sync your anime and manga preferences.',
      null,
      () => _connectMAL(),
      () => _disconnectMAL(),
      () => _getMALAuthUrl(),
    );
  }

  Widget _buildServiceTab(
    String serviceName,
    IconData icon,
    Color color,
    String description,
    dynamic state,
    VoidCallback onConnect,
    VoidCallback onDisconnect,
    VoidCallback onGetAuthUrl,
  ) {
    final isConnected = false; // TODO: Implement connection status
    final isLoading = false; // TODO: Implement loading status

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceHeader(serviceName, icon, color, description),
          const SizedBox(height: 24),
          _buildConnectionStatus(isConnected, isLoading),
          const SizedBox(height: 24),
          if (isConnected)
            _buildConnectedActions(onDisconnect)
          else
            _buildConnectionActions(onConnect, onGetAuthUrl),
          const SizedBox(height: 24),
          _buildManualAuthSection(serviceName),
          const SizedBox(height: 24),
          _buildServiceFeatures(serviceName),
        ],
      ),
    );
  }

  Widget _buildServiceHeader(String serviceName, IconData icon, Color color, String description) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 64,
            color: color,
          ),
          const SizedBox(height: 16),
          Text(
            serviceName,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
              // textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(bool isConnected, bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.check_circle : Icons.cancel,
            color: isConnected ? Colors.green : Colors.red,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConnected ? 'Connected' : 'Not Connected',
                  style: TextStyle(
                    color: AppConstants.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isConnected
                      ? 'Your account is successfully connected'
                      : 'Connect your account to get started',
                  style: TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Widget _buildConnectedActions(VoidCallback onDisconnect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          text: 'Disconnect',
          onPressed: onDisconnect,
          backgroundColor: Colors.red,
        ),
        const SizedBox(height: 12),
        AppButton(
          text: 'View Profile',
          onPressed: () => _viewServiceProfile(),
          isOutlined: true,
        ),
        const SizedBox(height: 12),
        AppButton(
          text: 'Sync Data',
          onPressed: () => _syncServiceData(),
          isOutlined: true,
        ),
      ],
    );
  }

  Widget _buildConnectionActions(VoidCallback onConnect, VoidCallback onGetAuthUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          text: 'Connect with OAuth',
          onPressed: onGetAuthUrl,
        ),
        const SizedBox(height: 12),
        AppButton(
          text: 'Connect Manually',
          onPressed: onConnect,
          isOutlined: true,
        ),
      ],
    );
  }

  Widget _buildManualAuthSection(String serviceName) {
    final controller = _authControllers[serviceName.toLowerCase()];
    if (controller == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manual Authentication',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'If OAuth is not working, you can manually enter your authentication token.',
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: controller,
            labelText: 'Auth Token',
            hintText: 'Enter your authentication token',
            obscureText: true,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Connect with Token',
            onPressed: () => _connectWithToken(serviceName),
            isOutlined: true,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceFeatures(String serviceName) {
    final features = _getServiceFeatures(serviceName);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      color: AppConstants.textColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  List<String> _getServiceFeatures(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'spotify':
        return [
          'Sync your music library',
          'Import playlists',
          'Track listening history',
          'Control playback',
          'Discover new music',
        ];
      case 'youtube music':
        return [
          'Sync your music library',
          'Import playlists',
          'Track listening history',
          'Access YouTube Music content',
        ];
      case 'lastfm':
        return [
          'Track listening habits',
          'Discover new artists',
          'Get music recommendations',
          'View listening statistics',
        ];
      case 'myanimelist':
        return [
          'Sync anime preferences',
          'Import manga lists',
          'Get anime recommendations',
          'Track watching progress',
        ];
      default:
        return [];
    }
  }

  // Helper methods
  Color _getServiceColor(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'spotify':
        return Colors.green;
      case 'youtube music':
        return Colors.red;
      case 'lastfm':
        return Colors.purple;
      case 'myanimelist':
        return Colors.blue;
      default:
        return AppConstants.primaryColor;
    }
  }

  IconData _getServiceIcon(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'spotify':
        return Icons.music_note;
      case 'youtube music':
        return Icons.play_circle_filled;
      case 'lastfm':
        return Icons.radio;
      case 'myanimelist':
        return Icons.animation;
      default:
        return Icons.link;
    }
  }

  // Action methods
  void _launchUrl(String url) {
    // Implement URL launching logic
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _connectSpotify() {
    // TODO: Implement Spotify connect
    print('Connecting to Spotify...');
  }

  void _disconnectSpotify() {
    // TODO: Implement Spotify disconnect
    print('Disconnecting from Spotify...');
  }

  void _getSpotifyAuthUrl() {
    // TODO: Implement Spotify auth URL
    print('Getting Spotify auth URL...');
  }

  void _connectYTMusic() {
    // TODO: Implement YT Music connect
    print('Connecting to YouTube Music...');
  }

  void _disconnectYTMusic() {
    // TODO: Implement YT Music disconnect
    print('Disconnecting from YouTube Music...');
  }

  void _getYTMusicAuthUrl() {
    // TODO: Implement YT Music auth URL
    print('Getting YouTube Music auth URL...');
  }

  void _connectLastFM() {
    // TODO: Implement LastFM connect
    print('Connecting to LastFM...');
  }

  void _disconnectLastFM() {
    // TODO: Implement LastFM disconnect
    print('Disconnecting from LastFM...');
  }

  void _getLastFMAuthUrl() {
    // TODO: Implement LastFM auth URL
    print('Getting LastFM auth URL...');
  }

  void _connectMAL() {
    // TODO: Implement MAL connect
    print('Connecting to MyAnimeList...');
  }

  void _disconnectMAL() {
    // TODO: Implement MAL disconnect
    print('Disconnecting from MyAnimeList...');
  }

  void _getMALAuthUrl() {
    // TODO: Implement MAL auth URL
    print('Getting MyAnimeList auth URL...');
  }

  void _connectWithToken(String serviceName) {
    final controller = _authControllers[serviceName.toLowerCase()];
    if (controller != null && controller.text.isNotEmpty) {
      switch (serviceName.toLowerCase()) {
        case 'spotify':
          // TODO: Implement Spotify manual connect
          print('Manual Spotify connect with: ${controller.text}');
          break;
        case 'youtube music':
                      // TODO: Implement YT Music manual connect
            print('Manual YT Music connect with: ${controller.text}');
          break;
        case 'lastfm':
                      // TODO: Implement LastFM manual connect
            print('Manual LastFM connect with: ${controller.text}');
          break;
        case 'myanimelist':
                      // TODO: Implement MAL manual connect
            print('Manual MAL connect with: ${controller.text}');
          break;
      }
    }
  }

  void _viewServiceProfile() {
    // Implement view service profile logic
  }

  void _syncServiceData() {
    // Implement sync service data logic
  }
}