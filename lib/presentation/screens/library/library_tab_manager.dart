import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../core/theme/design_system.dart';

class LibraryTabManager extends StatefulWidget {
  final String selectedTab;
  final int selectedIndex;
  final Function(String) onTabChanged;

  const LibraryTabManager({
    super.key,
    required this.selectedTab,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  State<LibraryTabManager> createState() => _LibraryTabManagerState();
}

class _LibraryTabManagerState extends State<LibraryTabManager> {
  final List<String> _tabs = [
    'Playlists',
    'Liked Songs',
    'Downloads',
    'Recently Played',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _tabs.length,
          itemBuilder: (context, index) {
            final tab = _tabs[index];
            final isSelected = index == widget.selectedIndex;

            return Container(
              margin: EdgeInsets.only(
                right: index < _tabs.length - 1 ? 16 : 0,
              ),
              child: GestureDetector(
                onTap: () => _onTabTap(index, tab),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? DesignSystem.error
                        : DesignSystem.surfaceContainer,
                    borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
                    border: Border.all(
                      color: isSelected
                          ? DesignSystem.error
                          : DesignSystem.surfaceContainerHighest,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                  ),
                  child: Center(
                    child: Text(
                      tab,
                      style: DesignSystem.bodySmall.copyWith(
                        color: isSelected
                            ? DesignSystem.onPrimary
                            : DesignSystem.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onTabTap(int index, String tab) {
    setState(() {
      // Update local state if needed
    });

    // Notify parent of tab change
    widget.onTabChanged(tab);

    // Load items for selected tab
    String type = tab.toLowerCase().replaceAll(' ', '_');
    context.read<LibraryBloc>().add(LibraryItemsRequested(
      type: type,
    ));
  }
}