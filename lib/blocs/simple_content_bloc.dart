import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/mock_data_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:musicbud_flutter/config/api_config.dart'; // Added this import

// Simple Events
abstract class SimpleContentEvent extends Equatable {
  const SimpleContentEvent();
  @override
  List<Object?> get props => [];
}

class LoadTopTracks extends SimpleContentEvent {}

class LoadTopArtists extends SimpleContentEvent {}

class LoadBuds extends SimpleContentEvent {}

class LoadChats extends SimpleContentEvent {}

class LoadPlaylists extends SimpleContentEvent {}

class RefreshContent extends SimpleContentEvent {}

// Simple States
abstract class SimpleContentState extends Equatable {
  const SimpleContentState();
  @override
  List<Object?> get props => [];
}

class SimpleContentInitial extends SimpleContentState {}

class SimpleContentLoading extends SimpleContentState {}

class SimpleContentLoaded extends SimpleContentState {
  final List<Map<String, dynamic>> topTracks;
  final List<Map<String, dynamic>> topArtists;
  final List<Map<String, dynamic>> buds;
  final List<Map<String, dynamic>> chats;
  final List<Map<String, dynamic>> playlists;

  const SimpleContentLoaded({
    this.topTracks = const [],
    this.topArtists = const [],
    this.buds = const [],
    this.chats = const [],
    this.playlists = const [],
  });

  @override
  List<Object?> get props => [topTracks, topArtists, buds, chats, playlists];

  SimpleContentLoaded copyWith({
    List<Map<String, dynamic>>? topTracks,
    List<Map<String, dynamic>>? topArtists,
    List<Map<String, dynamic>>? buds,
    List<Map<String, dynamic>>? chats,
    List<Map<String, dynamic>>? playlists,
  }) {
    return SimpleContentLoaded(
      topTracks: topTracks ?? this.topTracks,
      topArtists: topArtists ?? this.topArtists,
      buds: buds ?? this.buds,
      chats: chats ?? this.chats,
      playlists: playlists ?? this.playlists,
    );
  }
}

class SimpleContentError extends SimpleContentState {
  final String message;

  const SimpleContentError(this.message);

  @override
  List<Object?> get props => [message];
}

// Simple ContentBloc
class SimpleContentBloc extends Bloc<SimpleContentEvent, SimpleContentState> {
  SimpleContentBloc() : super(SimpleContentInitial()) {
    on<LoadTopTracks>(_onLoadTopTracks);
    on<LoadTopArtists>(_onLoadTopArtists);
    on<LoadBuds>(_onLoadBuds);
    on<LoadChats>(_onLoadChats);
    on<LoadPlaylists>(_onLoadPlaylists);
    on<RefreshContent>(_onRefreshContent);
  }

  Future<void> _onLoadTopTracks(
    LoadTopTracks event,
    Emitter<SimpleContentState> emit,
  ) async {
    try {
      emit(SimpleContentLoading());
      
      // Try to load from real API first
      final tracks = await SimpleContentBloc._loadTracksFromAPI(); // Now static
      
      if (state is SimpleContentLoaded) {
        emit((state as SimpleContentLoaded).copyWith(topTracks: tracks));
      } else {
        emit(SimpleContentLoaded(topTracks: tracks));
      }
    } catch (e) {
      developer.log('Failed to load from API, using mock data: $e');
      // Fallback to mock data if API fails
      final tracks = MockDataService.generateTopTracks(count: 20);
      
      if (state is SimpleContentLoaded) {
        emit((state as SimpleContentLoaded).copyWith(topTracks: tracks));
      } else {
        emit(SimpleContentLoaded(topTracks: tracks));
      }
    }
  }

  Future<void> _onLoadTopArtists(
    LoadTopArtists event,
    Emitter<SimpleContentState> emit,
  ) async {
    try {
      if (state is! SimpleContentLoading) {
        emit(SimpleContentLoading());
      }
      
      // Try to load from real API first
      final artists = await SimpleContentBloc._loadArtistsFromAPI(); // Now static
      
      if (state is SimpleContentLoaded) {
        emit((state as SimpleContentLoaded).copyWith(topArtists: artists));
      } else {
        emit(SimpleContentLoaded(topArtists: artists));
      }
    } catch (e) {
      developer.log('Failed to load artists from API, using mock data: $e');
      // Fallback to mock data if API fails
      final artists = MockDataService.generateTopArtists(count: 15);
      
      if (state is SimpleContentLoaded) {
        emit((state as SimpleContentLoaded).copyWith(topArtists: artists));
      } else {
        emit(SimpleContentLoaded(topArtists: artists));
      }
    }
  }

  Future<void> _onLoadBuds(
    LoadBuds event,
    Emitter<SimpleContentState> emit,
  ) async {
    try {
      if (state is! SimpleContentLoading) {
        emit(SimpleContentLoading());
      }
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      final buds = MockDataService.generateBudRecommendations(count: 12);
      
      if (state is SimpleContentLoaded) {
        emit((state as SimpleContentLoaded).copyWith(buds: buds));
      } else {
        emit(SimpleContentLoaded(buds: buds));
      }
    } catch (e) {
      emit(SimpleContentError('Failed to load buds: ${e.toString()}'));
    }
  }

  Future<void> _onLoadChats(
    LoadChats event,
    Emitter<SimpleContentState> emit,
  ) async {
    try {
      if (state is! SimpleContentLoading) {
        emit(SimpleContentLoading());
      }
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      final chats = MockDataService.generateChats(count: 8);
      
      if (state is SimpleContentLoaded) {
        emit((state as SimpleContentLoaded).copyWith(chats: chats));
      } else {
        emit(SimpleContentLoaded(chats: chats));
      }
    } catch (e) {
      emit(SimpleContentError('Failed to load chats: ${e.toString()}'));
    }
  }

  Future<void> _onLoadPlaylists(
    LoadPlaylists event,
    Emitter<SimpleContentState> emit,
  ) async {
    try {
      if (state is! SimpleContentLoading) {
        emit(SimpleContentLoading());
      }
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      final playlists = MockDataService.generatePlaylists(count: 10);
      
      if (state is SimpleContentLoaded) {
        emit((state as SimpleContentLoaded).copyWith(playlists: playlists));
      } else {
        emit(SimpleContentLoaded(playlists: playlists));
      }
    } catch (e) {
      emit(SimpleContentError('Failed to load playlists: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshContent(
    RefreshContent event,
    Emitter<SimpleContentState> emit,
  ) async {
    try {
      emit(SimpleContentLoading());
      await Future.delayed(const Duration(seconds: 1)); // Simulate refresh delay
      
      final tracks = MockDataService.generateTopTracks(count: 20);
      final artists = MockDataService.generateTopArtists(count: 15);
      final buds = MockDataService.generateBudRecommendations(count: 12);
      final chats = MockDataService.generateChats(count: 8);
      final playlists = MockDataService.generatePlaylists(count: 10);
      
      emit(SimpleContentLoaded(
        topTracks: tracks,
        topArtists: artists,
        buds: buds,
        chats: chats,
        playlists: playlists,
      ));
    } catch (e) {
      emit(SimpleContentError('Failed to refresh content: ${e.toString()}'));
    }
  }
  
  // ==================== API HELPER METHODS ====================
  
  /// Load tracks from the real backend API
  static Future<List<Map<String, dynamic>>> _loadTracksFromAPI() async {
    try {
      // First try to get user's top tracks (requires auth)
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/me/top/tracks'),
        headers: {'Accept': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        developer.log('✅ Successfully loaded tracks from API: ${data.runtimeType}');
        
        // Handle both direct arrays and paginated responses
        List<dynamic> results = data is List ? data : data['results'] ?? [];
        return results.cast<Map<String, dynamic>>();
      } else {
        developer.log('❌ API returned ${response.statusCode}, trying content tracks');
        
        // Fallback to general content tracks
        final contentResponse = await http.get(
          Uri.parse('${ApiConfig.baseUrl}/content/tracks'),
          headers: {'Accept': 'application/json'},
        );
        
        if (contentResponse.statusCode == 200) {
          final data = json.decode(contentResponse.body);
          developer.log('✅ Successfully loaded content tracks from API');
          
          List<dynamic> results = data is List ? data : data['results'] ?? [];
          return results.cast<Map<String, dynamic>>();
        } else {
          throw Exception('Both endpoints failed: me/top/tracks (${response.statusCode}) and content/tracks (${contentResponse.statusCode})');
        }
      }
    } catch (e) {
      developer.log('🔄 API error, will use mock data: $e');
      rethrow;
    }
  }
  
  /// Load artists from the real backend API
  static Future<List<Map<String, dynamic>>> _loadArtistsFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/content/artists'),
        headers: {'Accept': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        developer.log('✅ Successfully loaded artists from API');
        
        List<dynamic> results = data is List ? data : data['results'] ?? [];
        return results.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Artists API returned ${response.statusCode}');
      }
    } catch (e) {
      developer.log('🔄 Artists API error, will use mock data: $e');
      rethrow;
    }
  }
  
  /// Check if backend is available
  static Future<bool> _isBackendAvailable() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/'),
      ).timeout(const Duration(seconds: 3));
      
      final isAvailable = response.statusCode == 200;
      developer.log(isAvailable ? '✅ Backend is available' : '❌ Backend returned ${response.statusCode}');
      return isAvailable;
    } catch (e) {
      developer.log('❌ Backend not available: $e');
      return false;
    }
  }
}