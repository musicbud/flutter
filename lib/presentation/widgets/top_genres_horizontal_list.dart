import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import 'common/modern_button.dart';
import 'mixins/interaction/hover_mixin.dart';
import 'mixins/interaction/focus_mixin.dart';

class TopGenresHorizontalList extends StatefulWidget {
  final List<String> initialGenres;
  final Future<List<String>> Function(int page) loadMoreGenres;
  final bool enableHover;
  final bool enableFocus;
  final bool showLoadMoreButton;

  const TopGenresHorizontalList({
    Key? key,
    required this.initialGenres,
    required this.loadMoreGenres,
    this.enableHover = true,
    this.enableFocus = true,
    this.showLoadMoreButton = true,
  }) : super(key: key);

  @override
  TopGenresHorizontalListState createState() => TopGenresHorizontalListState();
}

class TopGenresHorizontalListState extends State<TopGenresHorizontalList>
    with HoverMixin<TopGenresHorizontalList>, FocusMixin<TopGenresHorizontalList> {
  late List<String> _genres;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasReachedEnd = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _genres = widget.initialGenres;
    if (widget.enableHover) {
      setupHover(
        onHover: () {},
        onExit: () {},
        enableScaleAnimation: false,
      );
    }
    if (widget.enableFocus) {
      setupFocus(
        onFocus: () {},
        onUnfocus: () {},
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_isLoading || _hasReachedEnd) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final newGenres = await widget.loadMoreGenres(_currentPage + 1);
      if (newGenres.isNotEmpty) {
        setState(() {
          _genres.addAll(newGenres);
          _currentPage++;
        });
      } else {
        setState(() {
          _hasReachedEnd = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No more genres to load'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading genres: $e'),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    if (_isLoading && _genres.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 60,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: design.designSystemSpacing.md),
        itemCount: _genres.length + (widget.showLoadMoreButton && !_hasReachedEnd ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _genres.length) {
            return _buildLoadMoreButton();
          }
          return _buildGenreChip(_genres[index]);
        },
      ),
    );
  }

  Widget _buildGenreChip(String genre) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Padding(
      padding: EdgeInsets.all(design.designSystemSpacing.xs),
      child: FilterChip(
        label: Text(
          genre,
          style: design.designSystemTypography.bodySmall.copyWith(
            color: design.designSystemColors.onSurface,
          ),
        ),
        selected: false,
        onSelected: (selected) {
          // TODO: Implement genre selection/filtering
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected genre: $genre'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: design.designSystemColors.surfaceContainer,
        selectedColor: design.designSystemColors.primary,
        checkmarkColor: design.designSystemColors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(design.designSystemRadius.xl),
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.designSystemSpacing.sm),
      child: Center(
        child: ModernButton(
          text: 'Load More',
          onPressed: _isLoading ? null : _loadMore,
          variant: ModernButtonVariant.outline,
          size: ModernButtonSize.medium,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}
