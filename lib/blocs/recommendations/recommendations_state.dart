import 'package:equatable/equatable.dart';

abstract class RecommendationsState extends Equatable {
  const RecommendationsState();

  @override
  List<Object?> get props => [];
}

class RecommendationsInitial extends RecommendationsState {
  const RecommendationsInitial();
}

class RecommendationsLoading extends RecommendationsState {
  const RecommendationsLoading();
}

class RecommendationsLoaded extends RecommendationsState {
  final Map<String, dynamic> recommendations;
  final DateTime loadedAt;

  const RecommendationsLoaded({
    required this.recommendations,
    required this.loadedAt,
  });

  @override
  List<Object?> get props => [recommendations, loadedAt];

  // Helper getters for different recommendation types
  List<dynamic> get tracks => recommendations['tracks'] ?? [];
  List<dynamic> get artists => recommendations['artists'] ?? [];
  List<dynamic> get albums => recommendations['albums'] ?? [];
  List<dynamic> get genres => recommendations['genres'] ?? [];
  List<dynamic> get buds => recommendations['buds'] ?? [];
}

class RecommendationsError extends RecommendationsState {
  final String message;

  const RecommendationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class RecommendationsEmpty extends RecommendationsState {
  const RecommendationsEmpty();
}
