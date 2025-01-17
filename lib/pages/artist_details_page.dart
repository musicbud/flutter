import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';

class ArtistDetailsPage extends StatefulWidget {
  final String artistId;
  final String artistName;
  final ApiService apiService;

  const ArtistDetailsPage({
    Key? key,
    required this.artistId,
    required this.artistName,
    required this.apiService,
  }) : super(key: key);

  @override
  _ArtistDetailsPageState createState() => _ArtistDetailsPageState();
}

class _ArtistDetailsPageState extends State<ArtistDetailsPage> {
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _buds = [];

  Future<void> _getBudsByArtist() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Fetching buds for artist ID: ${widget.artistId}');
      final buds = await widget.apiService.getBudsByArtist(widget.artistId);
      setState(() {
        _buds = buds;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching buds: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.artistName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _getBudsByArtist,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Get Buds for This Artist'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_buds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buds who like this artist:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _buds.length,
                      itemBuilder: (context, index) {
                        final bud = _buds[index];
                        return ListTile(
                          title: Text(bud['username'] ?? 'Unknown User'),
                          subtitle: Text(bud['email'] ?? ''),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
