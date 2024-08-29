import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Artist {
  final String uid;
  final String name;
  final String spotifyId;
  final String? href;
  final int? popularity;
  final String? type;
  final String uri;
  final String spotifyUrl;
  final int? followers;
  final List<String>? images;
  final List<int>? imageHeights;
  final List<int>? imageWidths;
  final List<String> genres;

  Artist({
    required this.uid,
    required this.name,
    required this.spotifyId,
    this.href,
    this.popularity,
    this.type,
    required this.uri,
    required this.spotifyUrl,
    this.followers,
    this.images,
    this.imageHeights,
    this.imageWidths,
    required this.genres,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      spotifyId: json['spotify_id'] ?? '',
      href: json['href'],
      popularity: json['popularity'],
      type: json['type'],
      uri: json['uri'] ?? '',
      spotifyUrl: json['spotify_url'] ?? '',
      followers: json['followers'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      imageHeights: json['image_heights'] != null ? List<int>.from(json['image_heights']) : null,
      imageWidths: json['image_widthes'] != null ? List<int>.from(json['image_widthes']) : null,
      genres: List<String>.from(json['genres'] ?? []),
    );
  }
}

class TopArtistsResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Artist> data;
  final String message;
  final int code;
  final bool successful;

  TopArtistsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.data,
    required this.message,
    required this.code,
    required this.successful,
  });

  factory TopArtistsResponse.fromJson(Map<String, dynamic> json) {
    return TopArtistsResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      data: (json['data'] as List).map((item) => Artist.fromJson(item)).toList(),
      message: json['message'],
      code: json['code'],
      successful: json['successful'],
    );
  }
}

class TopArtistsPage extends StatefulWidget {
  const TopArtistsPage({super.key});

  @override
  _TopArtistsPageState createState() => _TopArtistsPageState();
}

class _TopArtistsPageState extends State<TopArtistsPage> {
  List<Artist> artists = [];
  String? nextPageUrl;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchTopArtists();
  }

  Future<void> fetchTopArtists({String? url}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzI0OTUxOTMxLCJpYXQiOjE3MjQ4NjU1MzEsImp0aSI6IjI3MWRiNzQ1OTk1NTQ4ZTdiODIzNTc1NTlmNjIyNzdlIiwidXNlcl9pZCI6MTQ0M30.JzecpN5LIP5XIasib9X1iDEmQ0IHZofOl2ycyVHEJ0E';
    const String sessionId = '8jnl9l28o3egdc25ezykc3v5may4o74i';

    try {
      final response = await http.post(
        Uri.parse(url ?? 'http://84.235.170.234/me/top/artists'),
        headers: {
          'Authorization': token,
          'Cookie': 'musicbud_sessionid=$sessionId',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final TopArtistsResponse topArtistsResponse = TopArtistsResponse.fromJson(responseData);
        setState(() {
          artists.addAll(topArtistsResponse.data);
          nextPageUrl = topArtistsResponse.next;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load artists: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Artists')),
      body: isLoading && artists.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: artists.length,
                  itemBuilder: (context, index) {
                    final artist = artists[index];
                    return ListTile(
                      title: Text(artist.name),
                      subtitle: Text(artist.genres.join(', ')),
                      trailing: Text(artist.spotifyId),
                    );
                  },
                ),
              ),
              if (nextPageUrl != null && !isLoading)
                ElevatedButton(
                  onPressed: () => fetchTopArtists(url: nextPageUrl),
                  child: const Text('Load More'),
                ),
              if (isLoading && artists.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicBud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TopArtistsPage(),
    );
  }
}
