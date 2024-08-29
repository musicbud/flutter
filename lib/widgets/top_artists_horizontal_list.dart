import 'package:flutter/material.dart';
import '../models/artist.dart';
import '../services/api_service.dart';

class TopArtistsHorizontalList extends StatefulWidget {
  @override
  _TopArtistsHorizontalListState createState() => _TopArtistsHorizontalListState();
}

class _TopArtistsHorizontalListState extends State<TopArtistsHorizontalList> {
  bool isLoading = true;
  String errorMessage = '';
  List<Artist> artists = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchTopArtists();
  }

  Future<void> fetchTopArtists() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await _apiService.fetchTopArtists();
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        // Extract the data field from the response
        final List<dynamic> data = response.data['data'];
        setState(() {
          isLoading = false;
          artists = data.map((json) => Artist.fromJson(json)).toList();
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load top artists';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    return SizedBox(
      height: 200, // Ensure the Column has a fixed height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.network(
                  artist.imageUrl ?? 'https://example.com/default_image.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey,
                      child: Icon(Icons.error),
                    );
                  },
                ),
                Text(artist.name ?? 'Unknown Artist'),
              ],
            ),
          );
        },
      ),
    );
  }
}
