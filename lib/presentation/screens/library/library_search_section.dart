import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../widgets/common/index.dart';

class LibrarySearchSection extends StatefulWidget {
  final String selectedTab;
  final TextEditingController searchController;

  const LibrarySearchSection({
    super.key,
    required this.selectedTab,
    required this.searchController,
  });

  @override
  State<LibrarySearchSection> createState() => _LibrarySearchSectionState();
}

class _LibrarySearchSectionState extends State<LibrarySearchSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ModernInputField(
        hintText: 'Search your library...',
        controller: widget.searchController,
        onChanged: _onSearch,
        size: ModernInputFieldSize.large,
      ),
    );
  }

  void _onSearch(String query) {
    String type = widget.selectedTab.toLowerCase().replaceAll(' ', '_');
    context.read<LibraryBloc>().add(LibraryItemsRequested(
      type: type,
      query: query.isNotEmpty ? query : null,
    ));
  }
}