import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer; // Add this line
import 'package:dio/dio.dart'; // Add this line
// import 'package:uni_links/uni_links.dart';
// import 'dart:async';

class ConnectServicesPage extends StatefulWidget {
  final ApiService apiService;

  const ConnectServicesPage({Key? key, required this.apiService}) : super(key: key);

  @override
  _ConnectServicesPageState createState() => _ConnectServicesPageState();
}

class _ConnectServicesPageState extends State<ConnectServicesPage> {
  bool _isSpotifyConnected = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkSpotifyConnection();
  }

  Future<void> _checkSpotifyConnection() async {
    final isConnected = await widget.apiService.isSpotifyConnected();
    setState(() {
      _isSpotifyConnected = isConnected;
    });
  }

  Future<void> _connectSpotify() async {
    try {
      final url = await widget.apiService.connectSpotify();
      developer.log('Received Spotify auth URL: $url');
      
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      developer.log('Error connecting to Spotify: $e');
      String errorMessage = 'Failed to connect to Spotify';
      if (e is DioException) {  // Use DioException for Dio 5.0.0+
        errorMessage += ': ${e.type} - ${e.message}';
      } else {
        errorMessage += ': $e';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Services'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _isSpotifyConnected
                ? Text('Spotify is connected')
                : ElevatedButton(
                    onPressed: _connectSpotify,
                    child: Text('Connect Spotify'),
                  ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:musicbud_flutter/services/api_service.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ConnectServicesPage extends StatefulWidget {
//   final ApiService apiService;

//   const ConnectServicesPage({Key? key, required this.apiService}) : super(key: key);

//   @override
//   _ConnectServicesPageState createState() => _ConnectServicesPageState();
// }

// class _ConnectServicesPageState extends State<ConnectServicesPage> {
//   Map<String, bool> _connectedServices = {
//     'Spotify': false,
//     'YouTube Music': false,
//     'Last.fm': false,
//     'MyAnimeList': false,
//     'Trakt': false,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _fetchConnectedServices();
//   }

//   Future<void> _fetchConnectedServices() async {
//     // TODO: Implement API call to fetch connected services
//     // For now, we'll use dummy data
//     setState(() {
//       _connectedServices = {
//         'Spotify': false,
//         'YouTube Music': false,
//         'Last.fm': false,
//         'MyAnimeList': false,
//         'Trakt': false,
//       };
//     });
//   }

//   Future<void> _connectService(String service) async {
//     String endpoint;
//     switch (service) {
//       case 'Spotify':
//         endpoint = '/spotify/connect';
//         break;
//       case 'YouTube Music':
//         endpoint = '/ytmusic/connect';
//         break;
//       case 'Last.fm':
//         endpoint = '/lastfm/connect';
//         break;
//       case 'MyAnimeList':
//         endpoint = '/mal/connect';
//         break;
//       case 'Trakt':
//         endpoint = '/trakt/connect';
//         break;
//       default:
//         throw Exception('Unknown service: $service');
//     }

//     try {
//       final response = await widget.apiService.dio.get(endpoint);
//       if (response.statusCode == 200 && response.data['url'] != null) {
//         final url = response.data['url'];
//         if (await canLaunch(url)) {
//           await launch(url);
//         } else {
//           throw Exception('Could not launch $url');
//         }
//       } else {
//         throw Exception('Failed to get connection URL');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to connect to $service: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Connect Services'),
//       ),
//       body: ListView(
//         children: _connectedServices.entries.map((entry) {
//           final service = entry.key;
//           final isConnected = entry.value;
//           return ListTile(
//             title: Text(service),
//             trailing: isConnected
//                 ? Icon(Icons.check_circle, color: Colors.green)
//                 : ElevatedButton(
//                     onPressed: () => _connectService(service),
//                     child: Text('Connect'),
//                   ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
