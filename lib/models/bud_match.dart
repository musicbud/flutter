import 'dart:convert';
import 'bud.dart';

class BudMatch {
  final Bud bud;
  final double similarityScore;

  BudMatch({required this.bud, required this.similarityScore});

  factory BudMatch.fromJson(Map<String, dynamic> json) {
    print('BudMatch JSON: $json');
    return BudMatch(
      bud: Bud.fromJson(json['bud'] ?? {}),
      similarityScore: (json['similarity_score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Bud {
  final String id;
  final String username;
  final String? email;

  Bud({required this.id, required this.username, this.email});

  factory Bud.fromJson(Map<String, dynamic> json) {
    print('Bud JSON: $json');
    final username = json['username']?.toString() ?? 'Unknown User';
    return Bud(
      id: username, // Use username as id
      username: username,
      email: json['email']?.toString(),
    );
  }
}
