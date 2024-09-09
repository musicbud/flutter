import 'dart:convert';
import 'bud.dart';

class BudMatch {
  final Bud bud;
  final double similarityScore;

  BudMatch({required this.bud, required this.similarityScore});

  factory BudMatch.fromJson(Map<String, dynamic> json) {
    return BudMatch(
      bud: Bud.fromJson(json['bud'] ?? {}),
      similarityScore: (json['similarity_score'] ?? 0).toDouble(),
    );
  }
}

class Bud {
  final String uid;  // Changed from 'id' to 'uid'
  final String username;
  final String? email;

  Bud({required this.uid, required this.username, this.email});  // Changed 'id' to 'uid'

  factory Bud.fromJson(Map<String, dynamic> json) {
    print('Bud JSON: $json');
    return Bud(
      uid: json['uid']?.toString() ?? '',  // Changed from 'username' to 'uid'
      username: json['username']?.toString() ?? 'Unknown User',
      email: json['email']?.toString(),
    );
  }
}
