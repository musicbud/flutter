import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../blocs/library/library_state.dart';
import '../../../services/dynamic_theme_service.dart';

class PlaylistCreationDialog extends StatefulWidget {
  final Map<String, dynamic>? existingPlaylist;
  final List<String>? selectedFolders;
  final Function(String name, String? description, bool isPrivate)? onPlaylistCreated;

  const PlaylistCreationDialog({
    super.key,
    this.existingPlaylist,
    this.selectedFolders,
    this.onPlaylistCreated,
  });

  @override
  State<PlaylistCreationDialog> createState() => _PlaylistCreationDialogState();
}

class _PlaylistCreationDialogState extends State<PlaylistCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final DynamicThemeService _theme = DynamicThemeService.instance;
  
  bool _isPrivate = false;
  bool _isLoading = false;
  String? _selectedFolderId;
  List<Map<String, dynamic>> _availableFolders = [];

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _loadFolders();
  }

  void _initializeForm() {
    if (widget.existingPlaylist != null) {
      _nameController.text = widget.existingPlaylist!['name'] ?? '';
      _descriptionController.text = widget.existingPlaylist!['description'] ?? '';
      _isPrivate = !(widget.existingPlaylist!['isPublic'] ?? true);
    }
  }

  void _loadFolders() {
    // Mock folder data - in real app, this would load from LibraryBloc
    _availableFolders = [
      {'id': 'folder_1', 'name': 'My Music'},
      {'id': 'folder_2', 'name': 'Favorites'},
      {'id': 'folder_3', 'name': 'Workout Playlists'},
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LibraryBloc, LibraryState>(
      listener: (context, state) {
        if (state is LibraryActionSuccess) {
          setState(() => _isLoading = false);
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is LibraryActionFailure) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(_theme.getDynamicSpacing(24)),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                SizedBox(height: _theme.getDynamicSpacing(24)),
                _buildNameField(),
                SizedBox(height: _theme.getDynamicSpacing(16)),
                _buildDescriptionField(),
                SizedBox(height: _theme.getDynamicSpacing(16)),
                _buildPrivacyToggle(),
                SizedBox(height: _theme.getDynamicSpacing(16)),
                _buildFolderSelector(),
                SizedBox(height: _theme.getDynamicSpacing(24)),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.playlist_add,
          size: _theme.getDynamicFontSize(48),
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: _theme.getDynamicSpacing(16)),
        Text(
          widget.existingPlaylist != null ? 'Edit Playlist' : 'Create New Playlist',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(24),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Playlist Name *',
        hintText: 'Enter playlist name',
        prefixIcon: const Icon(Icons.music_note),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a playlist name';
        }
        if (value.trim().length < 2) {
          return 'Playlist name must be at least 2 characters';
        }
        if (value.trim().length > 100) {
          return 'Playlist name must be less than 100 characters';
        }
        return null;
      },
      maxLength: 100,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Description (Optional)',
        hintText: 'Enter playlist description',
        prefixIcon: const Icon(Icons.description),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      maxLines: 3,
      maxLength: 500,
      validator: (value) {
        if (value != null && value.trim().length > 500) {
          return 'Description must be less than 500 characters';
        }
        return null;
      },
    );
  }

  Widget _buildPrivacyToggle() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Row(
          children: [
            Icon(
              _isPrivate ? Icons.lock : Icons.public,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: _theme.getDynamicSpacing(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isPrivate ? 'Private Playlist' : 'Public Playlist',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: _theme.getDynamicFontSize(16),
                    ),
                  ),
                  Text(
                    _isPrivate
                        ? 'Only you can see this playlist'
                        : 'Anyone can see this playlist',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: _theme.getDynamicFontSize(12),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isPrivate,
              onChanged: (value) => setState(() => _isPrivate = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderSelector() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: _theme.getDynamicSpacing(12)),
                Text(
                  'Add to Folder (Optional)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: _theme.getDynamicFontSize(16),
                  ),
                ),
              ],
            ),
            SizedBox(height: _theme.getDynamicSpacing(12)),
            DropdownButtonFormField<String>(
              initialValue: _selectedFolderId,
              decoration: InputDecoration(
                hintText: 'Select a folder',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: _theme.getDynamicSpacing(12),
                  vertical: _theme.getDynamicSpacing(8),
                ),
              ),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(
                    'No folder',
                    style: TextStyle(
                      fontSize: _theme.getDynamicFontSize(14),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                ..._availableFolders.map((folder) => DropdownMenuItem<String>(
                  value: folder['id'],
                  child: Text(
                    folder['name'],
                    style: TextStyle(
                      fontSize: _theme.getDynamicFontSize(14),
                    ),
                  ),
                )),
              ],
              onChanged: (value) => setState(() => _selectedFolderId = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: _theme.getDynamicSpacing(16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: _theme.getDynamicFontSize(16),
              ),
            ),
          ),
        ),
        SizedBox(width: _theme.getDynamicSpacing(12)),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: _theme.getDynamicSpacing(16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    widget.existingPlaylist != null ? 'Update' : 'Create',
                    style: TextStyle(
                      fontSize: _theme.getDynamicFontSize(16),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    // Use callback if provided, otherwise use BLoC
    if (widget.onPlaylistCreated != null) {
      widget.onPlaylistCreated!(
        name,
        description.isEmpty ? null : description,
        _isPrivate,
      );
      Navigator.of(context).pop(true);
      return;
    }

    if (widget.existingPlaylist != null) {
      // Update existing playlist
      context.read<LibraryBloc>().add(LibraryPlaylistUpdateRequested(
        playlistId: widget.existingPlaylist!['id'],
        name: name,
        description: description.isEmpty ? null : description,
        isPublic: !_isPrivate,
      ));
    } else {
      // Create new playlist
      context.read<LibraryBloc>().add(LibraryPlaylistCreated(
        name: name,
        description: description.isEmpty ? null : description,
        isPrivate: _isPrivate,
      ));

      // If a folder is selected, add playlist to folder after creation
      if (_selectedFolderId != null) {
        // This would be handled in the success state listener
        // by adding the playlist to the selected folder
      }
    }
  }
}