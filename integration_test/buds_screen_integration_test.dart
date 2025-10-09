import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

// App imports
import 'package:musicbud_flutter/main.dart';
import 'package:musicbud_flutter/presentation/screens/buds/buds_screen.dart';
import 'package:musicbud_flutter/blocs/bud_matching/bud_matching_bloc.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

// Test utilities
import 'test_utils/test_helpers.dart';
import 'test_utils/mock_api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('BudsScreen Integration Tests', () {
    late MockBudMatchingBloc mockBudMatchingBloc;
    late MockApiClient mockApiClient;

    setUp(() {
      mockBudMatchingBloc = MockBudMatchingBloc();
      mockApiClient = MockApiClient();
      TestSetup.setupMockDependencies();
    });

    tearDown(() {
      TestSetup.teardownMockDependencies();
    });

    testWidgets('BudsScreen renders correctly with initial state',
        (WidgetTester tester) async {
      // Arrange
      mockBudMatchingBloc.emit(BudMatchingInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<BudMatchingBloc>.value(value: mockBudMatchingBloc),
        ],
        child: const BudsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(BudsScreen));
      IntegrationTestUtils.expectTextVisible('Find Your Music Buds');
      expect(find.byType(ActionChip), findsWidgets);
    });

    testWidgets('BudsScreen triggers API call when top artists button is tapped',
        (WidgetTester tester) async {
      // Arrange
      mockBudMatchingBloc.emit(BudMatchingInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<BudMatchingBloc>.value(value: mockBudMatchingBloc),
        ],
        child: const BudsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Tap on "Top Artists" chip
      await tester.tap(find.text('Top Artists'));
      await tester.pumpAndSettle();

      // Assert
      verify(mockBudMatchingBloc.add(any)).called(1);
    });

    testWidgets('BudsScreen displays loading state correctly',
        (WidgetTester tester) async {
      // Arrange
      mockBudMatchingBloc.emit(BudMatchingLoading());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<BudMatchingBloc>.value(value: mockBudMatchingBloc),
        ],
        child: const BudsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(BudsScreen));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('BudsScreen displays search results correctly',
        (WidgetTester tester) async {
      // Arrange
      final testResult = TestData.testBudSearchResult;
      mockBudMatchingBloc.emit(BudsFound(searchResult: testResult));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<BudMatchingBloc>.value(value: mockBudMatchingBloc),
        ],
        child: const BudsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(BudsScreen));
      // Should display buds from the result
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('BudsScreen handles empty results correctly',
        (WidgetTester tester) async {
      // Arrange
      final emptyResult = TestData.emptyBudSearchResult;
      mockBudMatchingBloc.emit(BudsFound(searchResult: emptyResult));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<BudMatchingBloc>.value(value: mockBudMatchingBloc),
        ],
        child: const BudsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(BudsScreen));
      IntegrationTestUtils.expectTextVisible('No Buds Found');
    });

    testWidgets('BudsScreen handles error state correctly',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Failed to find buds';
      mockBudMatchingBloc.emit(BudMatchingError(message: errorMessage));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<BudMatchingBloc>.value(value: mockBudMatchingBloc),
        ],
        child: const BudsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(BudsScreen));
      IntegrationTestUtils.expectTextVisible('Search Failed');
      IntegrationTestUtils.expectTextVisible(errorMessage);
    });

    testWidgets('BudsScreen supports refresh functionality',
        (WidgetTester tester) async {
      // Arrange
      final testResult = TestData.testBudSearchResult;
      mockBudMatchingBloc.emit(BudsFound(searchResult: testResult));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<BudMatchingBloc>.value(value: mockBudMatchingBloc),
        ],
        child: const BudsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate refresh
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(BudsScreen));
      // Refresh should trigger another API call
      verify(mockBudMatchingBloc.add(any)).called(greaterThan(1));
    });
  });
}