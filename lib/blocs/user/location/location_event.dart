import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LocationSaveRequested extends LocationEvent {
  final double latitude;
  final double longitude;

  const LocationSaveRequested({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class PlayedTracksRequested extends LocationEvent {}

class PlayedTracksWithLocationRequested extends LocationEvent {}

class CurrentlyPlayedTracksRequested extends LocationEvent {}
