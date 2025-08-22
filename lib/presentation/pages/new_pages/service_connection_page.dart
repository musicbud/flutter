import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../domain/models/content_service.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _authControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ServiceAuthUrlReceived) {
          _launchAuthUrl(state.url, state.service);
        } else if (state is AuthError) {
          _showErrorSnackBar(state.message);
        } else if (state is AuthSuccess) {
          _showSuccessSnackBar('Service connected successfully!');
        }
      },
      child: AppScaffold(
        appBar: AppAppBar(
          title: 'Connect Services',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // Refresh token for connected services
                _refreshServiceTokens();
              },
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
      ),
    );
  }

  Widget _buildConnectedServicesOverview() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return _buildServicesOverview([
            ContentService(
              id: 'spotify',
              name: 'Spotify',
              iconUrl: '',
              status: 'active',
              isConnected: state.connectedServices['spotify'] ?? false,
            ),
            ContentService(
              id: 'ytmusic',
              name: 'YouTube Music',
              iconUrl: '',
              status: 'active',
              isConnected: state.connectedServices['ytmusic'] ?? false,
            ),
            ContentService(
              id: 'lastfm',
              name: 'Last.fm',
              iconUrl: '',
              status: 'active',
              isConnected: state.connectedServices['lastfm'] ?? false,
            ),
            ContentService(
              id: 'mal',
              name: 'MyAnimeList',
              iconUrl: '',
              status: 'active',
              isConnected: state.connectedServices['mal'] ?? false,
            ),
          ]);
        }
        return const SizedBox.shrink();
      },
    );
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
      backgroundColor: service.isConnected
          ? _getServiceColor(service.name).withOpacity(0.3)
          : AppConstants.surfaceColor,
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isConnected = state is Authenticated && (state.connectedServices['spotify'] ?? false);
        final isLoading = state is AuthLoading;

        return _buildServiceTab(
          'Spotify',
          Icons.music_note,
          Colors.green,
          'Connect your Spotify account to sync your music library, playlists, and listening history.',
          state,
          () => _connectSpotify(),
          () => _refreshSpotifyToken(),
          () => _getSpotifyAuthUrl(),
          isConnected,
          isLoading,
        );
      },
    );
  }

  Widget _buildYTMusicTab() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isConnected = state is Authenticated && (state.connectedServices['ytmusic'] ?? false);
        final isLoading = state is AuthLoading;

        return _buildServiceTab(
          'YouTube Music',
          Icons.play_circle_filled,
          Colors.red,
          'Connect your YouTube Music account to sync your music library and playlists.',
          state,
          () => _connectYTMusic(),
          () => _refreshYTMusicToken(),
          () => _getYTMusicAuthUrl(),
          isConnected,
          isLoading,
        );
      },
    );
  }

  Widget _buildLastFMTab() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isConnected = state is Authenticated && (state.connectedServices['lastfm'] ?? false);
        final isLoading = state is AuthLoading;

        return _buildServiceTab(
          'LastFM',
          Icons.radio,
          Colors.purple,
          'Connect your LastFM account to track your listening habits and discover new music.',
          state,
          () => _connectLastFM(),
          () => _refreshLastFMToken(),
          () => _getLastFMAuthUrl(),
          isConnected,
          isLoading,
        );
      },
    );
  }

  Widget _buildMALTab() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isConnected = state is Authenticated && (state.connectedServices['mal'] ?? false);
        final isLoading = state is AuthLoading;

        return _buildServiceTab(
          'MyAnimeList',
          Icons.animation,
          Colors.blue,
          'Connect your MyAnimeList account to sync your anime and manga preferences.',
          state,
          () => _connectMAL(),
          () => _refreshMALToken(),
          () => _getMALAuthUrl(),
          isConnected,
          isLoading,
        );
      },
    );
  }

  Widget _buildServiceTab(
    String serviceName,
    IconData icon,
    Color color,
    String description,
    dynamic state,
    VoidCallback onConnect,
    VoidCallback onRefreshToken,
    VoidCallback onGetAuthUrl,
    bool isConnected,
    bool isLoading,
  ) {
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
            _buildConnectedActions(onRefreshToken, serviceName)
          else
            _buildConnectionActions(onConnect, onGetAuthUrl),
          const SizedBox(height: 24),
          _buildManualAuthSection(serviceName),
          const SizedBox(height: 24),
          _buildServiceFeatures(serviceName),
          const SizedBox(height: 24),
          _buildServiceLimitations(serviceName),
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
            ),
            textAlign: TextAlign.center,
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

  Widget _buildConnectedActions(VoidCallback onRefreshToken, String serviceName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          text: 'Refresh Token',
          onPressed: onRefreshToken,
          backgroundColor: AppConstants.primaryColor,
        ),
        const SizedBox(height: 12),
        AppButton(
          text: 'View Profile',
          onPressed: () => _viewServiceProfile(serviceName),
          isOutlined: true,
        ),
        const SizedBox(height: 12),
        AppButton(
          text: 'Sync Data',
          onPressed: () => _syncServiceData(serviceName),
          isOutlined: true,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Service disconnection is not supported by the API. To disconnect, you may need to revoke access from the service provider.',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
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
            'If OAuth is not working, you can manually enter your authentication code.',
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: controller,
            labelText: 'Auth Code',
            hintText: 'Enter your authentication code',
            obscureText: false,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Connect with Code',
            onPressed: () => _connectWithCode(serviceName),
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

  Widget _buildServiceLimitations(String serviceName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Limitations',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Service disconnection is not supported by the API. You can only connect and refresh tokens.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
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
          'Token refresh support',
          'Discover new music',
        ];
      case 'youtube music':
        return [
          'Sync your music library',
          'Import playlists',
          'Track listening history',
          'Token refresh support',
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
  Future<void> _launchAuthUrl(String url, String service) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _showErrorSnackBar('Could not launch authentication URL');
    }
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
    final controller = _authControllers['spotify'];
    if (controller != null && controller.text.isNotEmpty) {
      context.read<AuthBloc>().add(ConnectService(service: 'spotify', code: controller.text));
    } else {
      _showErrorSnackBar('Please enter an authentication code');
    }
  }

  void _refreshSpotifyToken() {
    context.read<AuthBloc>().add(RefreshServiceToken('spotify'));
  }

  void _getSpotifyAuthUrl() {
    context.read<AuthBloc>().add(GetServiceAuthUrl('spotify'));
  }

  void _connectYTMusic() {
    final controller = _authControllers['ytmusic'];
    if (controller != null && controller.text.isNotEmpty) {
      context.read<AuthBloc>().add(ConnectService(service: 'ytmusic', code: controller.text));
    } else {
      _showErrorSnackBar('Please enter an authentication code');
    }
  }

  void _refreshYTMusicToken() {
    context.read<AuthBloc>().add(RefreshServiceToken('ytmusic'));
  }

  void _getYTMusicAuthUrl() {
    context.read<AuthBloc>().add(GetServiceAuthUrl('ytmusic'));
  }

  void _connectLastFM() {
    final controller = _authControllers['lastfm'];
    if (controller != null && controller.text.isNotEmpty) {
      context.read<AuthBloc>().add(ConnectService(service: 'lastfm', code: controller.text));
    } else {
      _showErrorSnackBar('Please enter an authentication code');
    }
  }

  void _refreshLastFMToken() {
    // Last.fm doesn't support token refresh
    _showErrorSnackBar('Token refresh not supported for Last.fm');
  }

  void _getLastFMAuthUrl() {
    context.read<AuthBloc>().add(GetServiceAuthUrl('lastfm'));
  }

  void _connectMAL() {
    final controller = _authControllers['mal'];
    if (controller != null && controller.text.isNotEmpty) {
      context.read<AuthBloc>().add(ConnectService(service: 'mal', code: controller.text));
    } else {
      _showErrorSnackBar('Please enter an authentication code');
    }
  }

  void _refreshMALToken() {
    // MAL doesn't support token refresh
    _showErrorSnackBar('Token refresh not supported for MyAnimeList');
  }

  void _getMALAuthUrl() {
    context.read<AuthBloc>().add(GetServiceAuthUrl('mal'));
  }

  void _connectWithCode(String serviceName) {
    final controller = _authControllers[serviceName.toLowerCase()];
    if (controller != null && controller.text.isNotEmpty) {
      switch (serviceName.toLowerCase()) {
        case 'spotify':
          _connectSpotify();
          break;
        case 'youtube music':
          _connectYTMusic();
          break;
        case 'lastfm':
          _connectLastFM();
          break;
        case 'myanimelist':
          _connectMAL();
          break;
      }
    } else {
      _showErrorSnackBar('Please enter an authentication code');
    }
  }

  void _viewServiceProfile(String serviceName) {
    // TODO: Implement view service profile logic
    _showErrorSnackBar('Service profile viewing not yet implemented');
  }

  void _syncServiceData(String serviceName) {
    // TODO: Implement sync service data logic
    _showErrorSnackBar('Service data syncing not yet implemented');
  }

  void _refreshServiceTokens() {
    // Refresh tokens for all connected services
    context.read<AuthBloc>().add(RefreshServiceToken('spotify'));
    context.read<AuthBloc>().add(RefreshServiceToken('ytmusic'));
  }
}