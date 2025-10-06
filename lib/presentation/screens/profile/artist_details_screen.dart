import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/bud_repository.dart';
import '../../../models/bud_match.dart';
import '../../../core/theme/app_theme.dart';
import '../../../injection_container.dart';

class ArtistDetailsScreen extends StatefulWidget {
  final String artistId;
  final String artistName;

  const ArtistDetailsScreen({
    super.key,
    required this.artistId,
    required this.artistName,
  });

  @override
  State<ArtistDetailsScreen> createState() => _ArtistDetailsScreenState();
}

class _ArtistDetailsScreenState extends State<ArtistDetailsScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  List<BudMatch> _buds = [];

  Future<void> _getBudsByArtist() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final buds = await sl<BudRepository>().getBudsByArtist(widget.artistId);
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
    final appTheme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Details'),
        backgroundColor: appTheme.colors.surface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: appTheme.gradients.backgroundGradient,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.artistName,
                  style: appTheme.typography.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _getBudsByArtist,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.colors.primary,
                    foregroundColor: appTheme.colors.onPrimary,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Get Buds for This Artist'),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: appTheme.colors.errorRed),
                  ),
                ),
              if (_buds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buds who like this artist:',
                        style: appTheme.typography.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _buds.length,
                        itemBuilder: (context, index) {
                          final bud = _buds[index];
                          return Card(
                            color: appTheme.colors.surface,
                            child: ListTile(
                              title: Text(
                                bud.username ?? 'Unknown User',
                                style: TextStyle(color: appTheme.colors.onSurface),
                              ),
                              subtitle: Text(
                                bud.email ?? '',
                                style: TextStyle(color: appTheme.colors.onSurfaceVariant),
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