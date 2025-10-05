import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/user_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final UserRepository _userRepository;

  LocationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LocationInitial()) {
    on<LocationSaveRequested>(_onLocationSaveRequested);
    on<PlayedTracksRequested>(_onPlayedTracksRequested);
    on<PlayedTracksWithLocationRequested>(_onPlayedTracksWithLocationRequested);
    on<CurrentlyPlayedTracksRequested>(_onCurrentlyPlayedTracksRequested);
  }

  Future<void> _onLocationSaveRequested(
    LocationSaveRequested event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(LocationLoading());
      await _userRepository.saveLocation(event.latitude, event.longitude);
      emit(LocationSaveSuccess());
    } catch (error) {
      emit(LocationFailure(error.toString()));
    }
  }

  Future<void> _onPlayedTracksRequested(
    PlayedTracksRequested event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(LocationLoading());
      final tracks = await _userRepository.getPlayedTracks();
      emit(PlayedTracksLoaded(tracks));
    } catch (error) {
      emit(LocationFailure(error.toString()));
    }
  }

  Future<void> _onPlayedTracksWithLocationRequested(
    PlayedTracksWithLocationRequested event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(LocationLoading());
      final tracks = await _userRepository.getPlayedTracksWithLocation();
      emit(PlayedTracksWithLocationLoaded(tracks));
    } catch (error) {
      emit(LocationFailure(error.toString()));
    }
  }

  Future<void> _onCurrentlyPlayedTracksRequested(
    CurrentlyPlayedTracksRequested event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(LocationLoading());
      final tracks = await _userRepository.getCurrentlyPlayedTracks();
      emit(CurrentlyPlayedTracksLoaded(tracks));
    } catch (error) {
      emit(LocationFailure(error.toString()));
    }
  }
}
