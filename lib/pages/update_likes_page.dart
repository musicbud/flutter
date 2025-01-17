import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';

class UpdateLikesPage extends StatefulWidget {
  final ApiService apiService;
  final String channelId;

  const UpdateLikesPage({
    Key? key,
    required this.apiService,
    required this.channelId,
  }) : super(key: key);

  @override
  _UpdateLikesPageState createState() => _UpdateLikesPageState();
}

class _UpdateLikesPageState extends State<UpdateLikesPage> {
  bool _isUpdating = false;
  String _updateStatus = '';

  Future<void> _updateLikes() async {
    setState(() {
      _isUpdating = true;
      _updateStatus = 'Updating likes...';
    });

    try {
      final result = await widget.apiService.updateLikes(widget.channelId);
      if (result['status'] == 'success') {
        setState(() {
          _updateStatus = 'Likes updated successfully!';
        });
      } else {
        setState(() {
          _updateStatus = result['message'];
        });
        if (result['message'].contains('No Spotify account found')) {
          _showConnectSpotifyDialog();
        }
      }
    } catch (e) {
      setState(() {
        _updateStatus = 'Error updating likes: $e';
      });
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  void _showConnectSpotifyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Spotify Account Not Connected'),
          content:
              const Text('Please connect your Spotify account to update your likes.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to the ConnectServicesPage or implement the logic to connect Spotify
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update My Likes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isUpdating)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _updateLikes,
                child: const Text('Update My Likes'),
              ),
            const SizedBox(height: 20),
            Text(_updateStatus),
          ],
        ),
      ),
    );
  }
}
