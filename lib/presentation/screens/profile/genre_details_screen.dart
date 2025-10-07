import 'package:flutter/material.dart';
import '../../../domain/repositories/bud_repository.dart';
import '../../../models/bud_match.dart';
import '../../../core/theme/design_system.dart';
import '../../../injection_container.dart';
import '../../../presentation/navigation/main_navigation.dart';
import '../../../presentation/navigation/navigation_drawer.dart';

class GenreDetailsScreen extends StatefulWidget {
  final String genreId;
  final String genreName;

  const GenreDetailsScreen({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  State<GenreDetailsScreen> createState() => _GenreDetailsScreenState();
}

class _GenreDetailsScreenState extends State<GenreDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final MainNavigationController _navigationController;
  bool _isLoading = false;
  String? _errorMessage;
  List<BudMatch> _buds = [];

  @override
  void initState() {
    super.initState();
    _navigationController = MainNavigationController();
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  Future<void> _getBudsByGenre() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final buds = await sl<BudRepository>().getBudsByGenre(widget.genreId);
      setState(() {
        _buds = buds;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching buds: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Genre Details'),
        backgroundColor: DesignSystem.surface,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: MainNavigationDrawer(
        navigationController: _navigationController,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: DesignSystem.gradientBackground,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.genreName,
                  style: DesignSystem.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _getBudsByGenre,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignSystem.primary,
                    foregroundColor: DesignSystem.onPrimary,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Get Buds for This Genre'),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: DesignSystem.error),
                  ),
                ),
              if (_buds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buds who like this genre:',
                        style: DesignSystem.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _buds.length,
                        itemBuilder: (context, index) {
                          final bud = _buds[index];
                          return Card(
                            color: DesignSystem.surface,
                            child: ListTile(
                              title: Text(
                                bud.username,
                                style: TextStyle(color: DesignSystem.onSurface),
                              ),
                              subtitle: Text(
                                bud.email ?? 'No email',
                                style: TextStyle(color: DesignSystem.onSurfaceVariant),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}