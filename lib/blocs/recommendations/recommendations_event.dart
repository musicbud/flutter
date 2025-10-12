import 'package:equatable/equatable.dart';

abstract class RecommendationsEvent extends Equatable {
  const RecommendationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecommendations extends RecommendationsEvent {
  const LoadRecommendations();
}

class RefreshRecommendations extends RecommendationsEvent {
  const RefreshRecommendations();
}

class LoadRecommendationsByType extends RecommendationsEvent {
  final String type; // 'artists', 'tracks', 'albums', 'genres'
  
  const LoadRecommendationsByType(this.type);
  
  @override
  List<Object?> get props => [type];
}
