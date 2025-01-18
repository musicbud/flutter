import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';

class GenreDetailsPage extends StatefulWidget {
  final String genreId;
  final String genreName;
  final ApiService apiService;

  const GenreDetailsPage({
    Key? key,
    required this.genreId,
    required this.genreName,
    required this.apiService,
  }) : super(key: key);

  @override
  _GenreDetailsPageState createState() => _GenreDetailsPageState();
}

class _GenreDetailsPageState extends State<GenreDetailsPage> {
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _buds = [];

  Future<void> _getBudsByGenre() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Fetching buds for genre ID: ${widget.genreId}');
      final buds = await widget.apiService.getBudsByGenre(widget.genreId);
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
        title: const Text('Genre Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.genreName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _getBudsByGenre,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Get Buds for This Genre'),
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
                      'Buds who like this genre:',
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
