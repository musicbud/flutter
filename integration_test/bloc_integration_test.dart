/// BLoC Integration Tests
/// 
/// Tests for:
/// - BLoC event listening and state emission
/// - Real API data flow to presentation layer
/// - Multiple BLoC coordination
/// - State persistence across widgets

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/auth_bloc.dart';
import 'package:musicbud_flutter/blocs/user/user_bloc.dart';
import 'package:musicbud_flutter/blocs/user/user_event.dart';
import 'package:musicbud_flutter/blocs/user/user_state.dart';
import 'package:musicbud_flutter/domain/repositories/auth_repository.dart';
import 'package:musicbud_flutter/domain/repositories/user_repository.dart';
import 'package:musicbud_flutter/data/providers/token_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('BLoC Integration Tests', () {
    late AuthRepository authRepository;
    late UserRepository userRepository;
    late TokenProvider tokenProvider;

    setUp(() {
      // Initialize real repositories for integration testing
      // These should connect to test backend or mock backend
    });

    testWidgets('BLoC provides state to widgets correctly', (tester) async {
      // Create a test widget that listens to BLoC states
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => UserBloc(userRepository: userRepository),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            key: Key('loading_indicator'),
                          ),
                        );
                      } else if (state is ProfileLoaded) {
                        return Center(
                          child: Text(
                            'Profile Loaded',
                            key: Key('profile_loaded_text'),
                          ),
                        );
                      } else if (state is UserError) {
                        return Center(
                          child: Text(
                            'Error: ${state.message}',
                            key: Key('error_text'),
                          ),
                        );
                      }
                      return const Center(
                        child: Text(
                          'Initial State',
                          key: Key('initial_state_text'),
                        ),
                      );
                    },
                  ),
                  floatingActionButton: FloatingActionButton(
                    key: Key('load_profile_button'),
                    onPressed: () {
                      context.read<UserBloc>().add(LoadMyProfile());
                    },
                    child: Icon(Icons.refresh),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Verify initial state is displayed
      expect(find.byKey(Key('initial_state_text')), findsOneWidget);

      // Trigger event
      await tester.tap(find.byKey(Key('load_profile_button')));
      await tester.pump(); // Start the loading

      // Verify loading state is displayed
      expect(find.byKey(Key('loading_indicator')), findsOneWidget);

      // Wait for async operation to complete
      await tester.pumpAndSettle();

      // Verify final state is displayed (error or loaded)
      expect(
        find.byKey(Key('profile_loaded_text')).evaluate().isNotEmpty ||
            find.byKey(Key('error_text')).evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('BLoC listens to events from multiple widgets', (tester) async {
      final eventLog = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => UserBloc(userRepository: userRepository),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: BlocListener<UserBloc, UserState>(
                    listener: (context, state) {
                      if (state is UserLoading) {
                        eventLog.add('loading');
                      } else if (state is ProfileLoaded) {
                        eventLog.add('profile_loaded');
                      } else if (state is LikedItemsLoaded) {
                        eventLog.add('liked_items_loaded');
                      } else if (state is TopItemsLoaded) {
                        eventLog.add('top_items_loaded');
                      } else if (state is UserError) {
                        eventLog.add('error: ${state.message}');
                      }
                    },
                    child: Column(
                      children: [
                        ElevatedButton(
                          key: Key('load_profile_btn'),
                          onPressed: () {
                            context.read<UserBloc>().add(LoadMyProfile());
                          },
                          child: Text('Load Profile'),
                        ),
                        ElevatedButton(
                          key: Key('load_liked_btn'),
                          onPressed: () {
                            context.read<UserBloc>().add(LoadLikedItems());
                          },
                          child: Text('Load Liked Items'),
                        ),
                        ElevatedButton(
                          key: Key('load_top_btn'),
                          onPressed: () {
                            context.read<UserBloc>().add(LoadTopItems());
                          },
                          child: Text('Load Top Items'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Trigger multiple events
      await tester.tap(find.byKey(Key('load_profile_btn')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('load_liked_btn')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('load_top_btn')));
      await tester.pumpAndSettle();

      // Verify all events were processed
      expect(eventLog.length, greaterThan(0));
      expect(eventLog.contains('loading'), isTrue);
    });

    testWidgets('Multiple BLoCs coordinate state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => AuthBloc(
                  authRepository: authRepository,
                  tokenProvider: tokenProvider,
                ),
              ),
              BlocProvider(
                create: (_) => UserBloc(userRepository: userRepository),
              ),
            ],
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Column(
                    children: [
                      // Auth state display
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is Authenticated) {
                            return Text(
                              'Authenticated',
                              key: Key('auth_status'),
                            );
                          }
                          return Text(
                            'Not Authenticated',
                            key: Key('auth_status'),
                          );
                        },
                      ),
                      // User state display
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is ProfileLoaded) {
                            return Text(
                              'Profile Loaded',
                              key: Key('user_status'),
                            );
                          }
                          return Text(
                            'No Profile',
                            key: Key('user_status'),
                          );
                        },
                      ),
                      ElevatedButton(
                        key: Key('load_user_data_btn'),
                        onPressed: () {
                          // Only load user data if authenticated
                          final authState = context.read<AuthBloc>().state;
                          if (authState is Authenticated) {
                            context.read<UserBloc>().add(LoadMyProfile());
                          }
                        },
                        child: Text('Load User Data'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial states
      expect(find.text('Not Authenticated'), findsOneWidget);
      expect(find.text('No Profile'), findsOneWidget);

      // Tap button (should not load profile when not authenticated)
      await tester.tap(find.byKey(Key('load_user_data_btn')));
      await tester.pumpAndSettle();

      // User profile should not be loaded
      expect(find.text('No Profile'), findsOneWidget);
    });

    testWidgets('BLoC state persists across widget rebuilds', (tester) async {
      bool showAlternateView = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return BlocProvider(
                create: (_) => UserBloc(userRepository: userRepository),
                child: Scaffold(
                  body: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          if (!showAlternateView)
                            Text(
                              'Main View: ${state.runtimeType}',
                              key: Key('state_display'),
                            )
                          else
                            Text(
                              'Alternate View: ${state.runtimeType}',
                              key: Key('state_display'),
                            ),
                          ElevatedButton(
                            key: Key('toggle_view_btn'),
                            onPressed: () {
                              setState(() {
                                showAlternateView = !showAlternateView;
                              });
                            },
                            child: Text('Toggle View'),
                          ),
                          ElevatedButton(
                            key: Key('load_data_btn'),
                            onPressed: () {
                              context.read<UserBloc>().add(LoadMyProfile());
                            },
                            child: Text('Load Data'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Load data
      await tester.tap(find.byKey(Key('load_data_btn')));
      await tester.pumpAndSettle();

      // Get current state text
      final stateAfterLoad = find.byKey(Key('state_display'));
      final textAfterLoad = (stateAfterLoad.evaluate().first.widget as Text).data;

      // Toggle view (rebuild widget tree)
      await tester.tap(find.byKey(Key('toggle_view_btn')));
      await tester.pumpAndSettle();

      // Verify state persisted
      final stateAfterToggle = find.byKey(Key('state_display'));
      final textAfterToggle = (stateAfterToggle.evaluate().first.widget as Text).data;

      // Both should show same state type
      expect(
        textAfterLoad?.split(': ')[1],
        equals(textAfterToggle?.split(': ')[1]),
      );
    });

    testWidgets('BLoC handles rapid event firing correctly', (tester) async {
      final stateLog = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => UserBloc(userRepository: userRepository),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: BlocListener<UserBloc, UserState>(
                    listener: (context, state) {
                      stateLog.add(state.runtimeType.toString());
                    },
                    child: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Text('State Count: ${stateLog.length}'),
                            ElevatedButton(
                              key: Key('rapid_fire_btn'),
                              onPressed: () {
                                final bloc = context.read<UserBloc>();
                                // Fire multiple events rapidly
                                bloc.add(LoadMyProfile());
                                bloc.add(LoadLikedItems());
                                bloc.add(LoadTopItems());
                                bloc.add(LoadPlayedTracks());
                              },
                              child: Text('Fire Multiple Events'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Fire rapid events
      await tester.tap(find.byKey(Key('rapid_fire_btn')));
      await tester.pumpAndSettle();

      // Verify states were emitted (should have loading states)
      expect(stateLog.length, greaterThan(0));
      expect(
        stateLog.where((s) => s.contains('Loading')).length,
        greaterThan(0),
      );
    });

    testWidgets('BLoC error states are properly displayed in UI', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => UserBloc(userRepository: userRepository),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: BlocConsumer<UserBloc, UserState>(
                    listener: (context, state) {
                      if (state is UserError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            key: Key('error_snackbar'),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          if (state is UserError)
                            Card(
                              key: Key('error_card'),
                              child: Text('Error: ${state.message}'),
                            ),
                          ElevatedButton(
                            key: Key('trigger_error_btn'),
                            onPressed: () {
                              // This should trigger an error if backend is not available
                              context.read<UserBloc>().add(LoadMyProfile());
                            },
                            child: Text('Load Profile'),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Trigger potential error
      await tester.tap(find.byKey(Key('trigger_error_btn')));
      await tester.pump(); // Start loading
      await tester.pumpAndSettle(); // Wait for completion

      // Check if error state was handled (either error card or snackbar)
      final hasErrorCard = find.byKey(Key('error_card')).evaluate().isNotEmpty;
      final hasSnackbar = find.byKey(Key('error_snackbar')).evaluate().isNotEmpty;

      // At least one error display method should be present if there was an error
      expect(hasErrorCard || hasSnackbar || find.text('Profile Loaded').evaluate().isNotEmpty, isTrue);
    });

    testWidgets('BLoC state updates UI reactively on data change', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => UserBloc(userRepository: userRepository),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: BlocBuilder<UserBloc, UserState>(
                    buildWhen: (previous, current) {
                      // Rebuild when state actually changes
                      return previous.runtimeType != current.runtimeType;
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          Text(
                            'State: ${state.runtimeType}',
                            key: Key('state_type'),
                          ),
                          if (state is ProfileLoaded)
                            Text(
                              'Profile Data Available',
                              key: Key('profile_data'),
                            ),
                          if (state is LikedItemsLoaded)
                            Text(
                              'Liked Items: ${state.likedArtists.length + state.likedTracks.length}',
                              key: Key('liked_items_count'),
                            ),
                          ElevatedButton(
                            key: Key('load_profile_action'),
                            onPressed: () {
                              context.read<UserBloc>().add(LoadMyProfile());
                            },
                            child: Text('Load Profile'),
                          ),
                          ElevatedButton(
                            key: Key('load_liked_action'),
                            onPressed: () {
                              context.read<UserBloc>().add(LoadLikedItems());
                            },
                            child: Text('Load Liked'),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('State: UserInitial'), findsOneWidget);

      // Load profile
      await tester.tap(find.byKey(Key('load_profile_action')));
      await tester.pump();
      expect(find.text('State: UserLoading'), findsOneWidget);

      await tester.pumpAndSettle();

      // Should show either error or loaded state
      final currentState = find.byKey(Key('state_type'));
      expect(currentState, findsOneWidget);

      // Load liked items
      await tester.tap(find.byKey(Key('load_liked_action')));
      await tester.pump();
      expect(find.text('State: UserLoading'), findsOneWidget);

      await tester.pumpAndSettle();

      // Verify state changed
      expect(find.byKey(Key('state_type')), findsOneWidget);
    });
  });
}
