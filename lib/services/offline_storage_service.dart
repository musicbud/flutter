import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing offline data storage and synchronization
class OfflineStorageService {
  static OfflineStorageService? _instance;
  static OfflineStorageService get instance => _instance ??= OfflineStorageService._();

  OfflineStorageService._();

  SharedPreferences? _prefs;
  String? _documentsPath;
  
  // Storage keys
  static const String _libraryItemsKey = 'offline_library_items';
  static const String _playlistsKey = 'offline_playlists';
  static const String _downloadsKey = 'offline_downloads';
  static const String _downloadQueueKey = 'download_queue';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _offlineModeKey = 'offline_mode_enabled';
  static const String _syncSettingsKey = 'sync_settings';
  
  /// Initialize the offline storage service
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    
    final documentsDir = await getApplicationDocumentsDirectory();
    _documentsPath = documentsDir.path;
    
    // Create necessary directories
    await _createDirectories();
  }

  /// Create necessary directories for offline storage
  Future<void> _createDirectories() async {
    if (_documentsPath == null) return;
    
    final directories = [
      'offline_audio',
      'offline_images',
      'offline_playlists',
      'cache',
    ];
    
    for (final dir in directories) {
      final directory = Directory('$_documentsPath/$dir');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    }
  }

  /// Save library items for offline access
  Future<void> saveLibraryItems(List<Map<String, dynamic>> items) async {
    await _prefs?.setString(_libraryItemsKey, jsonEncode(items));
  }

  /// Get saved library items
  Future<List<Map<String, dynamic>>> getLibraryItems() async {
    final itemsJson = _prefs?.getString(_libraryItemsKey);
    if (itemsJson == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(itemsJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Save playlists for offline access
  Future<void> savePlaylists(List<Map<String, dynamic>> playlists) async {
    await _prefs?.setString(_playlistsKey, jsonEncode(playlists));
  }

  /// Get saved playlists
  Future<List<Map<String, dynamic>>> getPlaylists() async {
    final playlistsJson = _prefs?.getString(_playlistsKey);
    if (playlistsJson == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(playlistsJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Save downloads for offline access
  Future<void> saveDownloads(List<Map<String, dynamic>> downloads) async {
    await _prefs?.setString(_downloadsKey, jsonEncode(downloads));
  }

  /// Get saved downloads
  Future<List<Map<String, dynamic>>> getDownloads() async {
    final downloadsJson = _prefs?.getString(_downloadsKey);
    if (downloadsJson == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(downloadsJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Save download queue
  Future<void> saveDownloadQueue(List<Map<String, dynamic>> queue) async {
    await _prefs?.setString(_downloadQueueKey, jsonEncode(queue));
  }

  /// Get download queue
  Future<List<Map<String, dynamic>>> getDownloadQueue() async {
    final queueJson = _prefs?.getString(_downloadQueueKey);
    if (queueJson == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(queueJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Set offline mode status
  Future<void> setOfflineMode(bool enabled) async {
    await _prefs?.setBool(_offlineModeKey, enabled);
  }

  /// Check if offline mode is enabled
  bool isOfflineMode() {
    return _prefs?.getBool(_offlineModeKey) ?? false;
  }

  /// Set last sync timestamp
  Future<void> setLastSyncTime(DateTime timestamp) async {
    await _prefs?.setInt(_lastSyncKey, timestamp.millisecondsSinceEpoch);
  }

  /// Get last sync timestamp
  DateTime? getLastSyncTime() {
    final timestamp = _prefs?.getInt(_lastSyncKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  /// Save sync settings
  Future<void> saveSyncSettings(Map<String, dynamic> settings) async {
    await _prefs?.setString(_syncSettingsKey, jsonEncode(settings));
  }

  /// Get sync settings
  Future<Map<String, dynamic>> getSyncSettings() async {
    final settingsJson = _prefs?.getString(_syncSettingsKey);
    if (settingsJson == null) return _defaultSyncSettings();
    
    try {
      return jsonDecode(settingsJson);
    } catch (e) {
      return _defaultSyncSettings();
    }
  }

  /// Default sync settings
  Map<String, dynamic> _defaultSyncSettings() {
    return {
      'autoSync': true,
      'syncOnWifiOnly': true,
      'syncInterval': 30, // minutes
      'maxDownloadSize': 500, // MB
      'downloadQuality': 'high',
    };
  }

  /// Download and save audio file
  Future<String?> downloadAudioFile(String url, String itemId) async {
    if (_documentsPath == null) return null;
    
    try {
      // In a real implementation, this would download the actual audio file
      // For now, we'll create a placeholder file
      final filePath = '$_documentsPath/offline_audio/$itemId.mp3';
      final file = File(filePath);
      
      // Simulate download with placeholder content
      await file.writeAsString('placeholder_audio_content_for_$itemId');
      
      return filePath;
    } catch (e) {
      return null;
    }
  }

  /// Download and save image file
  Future<String?> downloadImageFile(String url, String itemId) async {
    if (_documentsPath == null) return null;
    
    try {
      // In a real implementation, this would download the actual image file
      // For now, we'll create a placeholder file
      final filePath = '$_documentsPath/offline_images/$itemId.jpg';
      final file = File(filePath);
      
      // Simulate download with placeholder content
      await file.writeAsString('placeholder_image_content_for_$itemId');
      
      return filePath;
    } catch (e) {
      return null;
    }
  }

  /// Check if audio file exists locally
  Future<bool> hasAudioFile(String itemId) async {
    if (_documentsPath == null) return false;
    
    final file = File('$_documentsPath/offline_audio/$itemId.mp3');
    return await file.exists();
  }

  /// Check if image file exists locally
  Future<bool> hasImageFile(String itemId) async {
    if (_documentsPath == null) return false;
    
    final file = File('$_documentsPath/offline_images/$itemId.jpg');
    return await file.exists();
  }

  /// Get local audio file path
  String? getAudioFilePath(String itemId) {
    if (_documentsPath == null) return null;
    return '$_documentsPath/offline_audio/$itemId.mp3';
  }

  /// Get local image file path
  String? getImageFilePath(String itemId) {
    if (_documentsPath == null) return null;
    return '$_documentsPath/offline_images/$itemId.jpg';
  }

  /// Delete audio file
  Future<bool> deleteAudioFile(String itemId) async {
    if (_documentsPath == null) return false;
    
    try {
      final file = File('$_documentsPath/offline_audio/$itemId.mp3');
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Delete image file
  Future<bool> deleteImageFile(String itemId) async {
    if (_documentsPath == null) return false;
    
    try {
      final file = File('$_documentsPath/offline_images/$itemId.jpg');
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    if (_documentsPath == null) {
      return {
        'totalSize': 0,
        'audioSize': 0,
        'imageSize': 0,
        'totalFiles': 0,
        'audioFiles': 0,
        'imageFiles': 0,
      };
    }

    try {
      final audioDir = Directory('$_documentsPath/offline_audio');
      final imageDir = Directory('$_documentsPath/offline_images');
      
      int audioSize = 0;
      int imageSize = 0;
      int audioFiles = 0;
      int imageFiles = 0;
      
      // Calculate audio directory size
      if (await audioDir.exists()) {
        await for (final entity in audioDir.list()) {
          if (entity is File) {
            final stat = await entity.stat();
            audioSize += stat.size;
            audioFiles++;
          }
        }
      }
      
      // Calculate image directory size
      if (await imageDir.exists()) {
        await for (final entity in imageDir.list()) {
          if (entity is File) {
            final stat = await entity.stat();
            imageSize += stat.size;
            imageFiles++;
          }
        }
      }
      
      return {
        'totalSize': audioSize + imageSize,
        'audioSize': audioSize,
        'imageSize': imageSize,
        'totalFiles': audioFiles + imageFiles,
        'audioFiles': audioFiles,
        'imageFiles': imageFiles,
      };
    } catch (e) {
      return {
        'totalSize': 0,
        'audioSize': 0,
        'imageSize': 0,
        'totalFiles': 0,
        'audioFiles': 0,
        'imageFiles': 0,
      };
    }
  }

  /// Clear all offline data
  Future<void> clearAllOfflineData() async {
    await _prefs?.remove(_libraryItemsKey);
    await _prefs?.remove(_playlistsKey);
    await _prefs?.remove(_downloadsKey);
    await _prefs?.remove(_downloadQueueKey);
    
    // Clear offline files
    if (_documentsPath != null) {
      try {
        final audioDir = Directory('$_documentsPath/offline_audio');
        final imageDir = Directory('$_documentsPath/offline_images');
        final playlistDir = Directory('$_documentsPath/offline_playlists');
        
        if (await audioDir.exists()) {
          await audioDir.delete(recursive: true);
        }
        
        if (await imageDir.exists()) {
          await imageDir.delete(recursive: true);
        }
        
        if (await playlistDir.exists()) {
          await playlistDir.delete(recursive: true);
        }
        
        // Recreate directories
        await _createDirectories();
      } catch (e) {
        // Handle error silently
      }
    }
  }

  /// Sync data from server (placeholder implementation)
  Future<bool> syncWithServer({
    required bool forceSync,
    String? syncType,
  }) async {
    try {
      // In a real implementation, this would sync with actual server
      // For now, we'll simulate sync process
      
      final settings = await getSyncSettings();
      final lastSync = getLastSyncTime();
      final now = DateTime.now();
      
      // Check if sync is needed
      if (!forceSync && lastSync != null) {
        final syncInterval = settings['syncInterval'] as int? ?? 30;
        final minutesSinceLastSync = now.difference(lastSync).inMinutes;
        
        if (minutesSinceLastSync < syncInterval) {
          return false; // No sync needed
        }
      }
      
      // Simulate sync delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Update last sync time
      await setLastSyncTime(now);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check storage space and clean up if needed
  Future<void> cleanupIfNeeded() async {
    final stats = await getStorageStats();
    final maxSize = (await getSyncSettings())['maxDownloadSize'] as int? ?? 500;
    final maxSizeBytes = maxSize * 1024 * 1024; // Convert MB to bytes
    
    if (stats['totalSize'] > maxSizeBytes) {
      // Remove oldest downloads to free up space
      final downloads = await getDownloads();
      
      // Sort by date, oldest first
      downloads.sort((a, b) {
        final dateA = DateTime.tryParse(a['downloadedAt'] ?? '') ?? DateTime.now();
        final dateB = DateTime.tryParse(b['downloadedAt'] ?? '') ?? DateTime.now();
        return dateA.compareTo(dateB);
      });
      
      // Remove oldest 25% of downloads
      final itemsToRemove = (downloads.length * 0.25).ceil();
      for (int i = 0; i < itemsToRemove && i < downloads.length; i++) {
        final download = downloads[i];
        final itemId = download['itemId'] ?? download['id'];
        if (itemId != null) {
          await deleteAudioFile(itemId);
          await deleteImageFile(itemId);
        }
      }
      
      // Update downloads list
      final remainingDownloads = downloads.skip(itemsToRemove).toList();
      await saveDownloads(remainingDownloads);
    }
  }

  /// Dispose of resources
  void dispose() {
    // Clean up any resources if needed
  }
}