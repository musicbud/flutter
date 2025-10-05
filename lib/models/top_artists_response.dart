import 'artist.dart';

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
