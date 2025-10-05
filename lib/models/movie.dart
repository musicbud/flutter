class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String director;
  // Add other relevant fields

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.director,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterUrl: json['poster_url'] ?? '',
      director: json['director'] ?? '',
      // Parse other fields
    );
  }
}
