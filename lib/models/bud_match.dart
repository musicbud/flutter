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

