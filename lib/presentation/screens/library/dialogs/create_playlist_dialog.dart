import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/library/library_bloc.dart';
import '../../../../blocs/library/library_event.dart';
import '../../../widgets/common/index.dart';
import '../../../../core/theme/design_system.dart';

class CreatePlaylistDialog extends StatefulWidget {
  const CreatePlaylistDialog({super.key});

  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isPrivate = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Create Playlist',
        style: DesignSystem.headlineSmall.copyWith(
          color: DesignSystem.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ModernInputField(
            controller: _nameController,
            hintText: 'Playlist Name',
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          ModernInputField(
            controller: _descController,
            hintText: 'Description (optional)',
            maxLines: 3,
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          CheckboxListTile(
            title: const Text(
              'Private Playlist',
              style: DesignSystem.bodyMedium,
            ),
            value: _isPrivate,
            onChanged: (value) {
              setState(() {
                _isPrivate = value ?? false;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        PrimaryButton(
          text: 'Create',
          onPressed: _onCreatePressed,
        ),
      ],
    );
  }

  void _onCreatePressed() {
    if (_nameController.text.isNotEmpty) {
      context.read<LibraryBloc>().add(LibraryPlaylistCreated(
        name: _nameController.text,
        description: _descController.text,
        isPrivate: _isPrivate,
      ));
      Navigator.pop(context);
    }
  }
}