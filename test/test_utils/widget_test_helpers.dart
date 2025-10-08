import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';
import 'test_helpers.dart';
import 'package:musicbud_flutter/domain/repositories/auth_repository.dart';
import 'package:musicbud_flutter/domain/repositories/user_repository.dart';
import 'package:musicbud_flutter/domain/repositories/profile_repository.dart';
import 'package:musicbud_flutter/domain/repositories/content_repository.dart';
import 'package:musicbud_flutter/domain/repositories/user_profile_repository.dart';
import 'package:musicbud_flutter/domain/repositories/settings_repository.dart';

// Import BLoCs
import 'package:musicbud_flutter/blocs/auth/auth_bloc.dart';
import 'package:musicbud_flutter/blocs/user/user_bloc.dart';
import 'package:musicbud_flutter/blocs/profile/profile_bloc.dart';
import 'package:musicbud_flutter/blocs/settings/settings_bloc.dart';
import 'package:musicbud_flutter/blocs/main/main_screen_bloc.dart';
import 'package:musicbud_flutter/blocs/user_profile/user_profile_bloc.dart';

/// Widget test helper utilities
class WidgetTestHelper {
  /// Creates a testable widget wrapped with MaterialApp and necessary providers
  static Widget createTestableWidget({
    required Widget child,
    ThemeData? theme,
    Locale? locale,
    List<BlocProvider>? blocProviders,
    List<ChangeNotifierProvider>? providers,
    NavigatorObserver? navigatorObserver,
    RouteFactory? onGenerateRoute,
  }) {
    return MaterialApp(
      theme: theme ?? DesignSystem.lightTheme,
      locale: locale ?? const Locale('en'),
      navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
      onGenerateRoute: onGenerateRoute,
      home: MultiBlocProvider(
        providers: blocProviders ?? [],
        child: MultiProvider(
          providers: providers ?? [],
          child: MediaQuery(
            data: const MediaQueryData(),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Pumps a widget with common test setup
  static Future<void> pumpWidget(
    WidgetTester tester,
    Widget widget, {
    Size? size,
    ThemeData? theme,
    List<BlocProvider>? blocProviders,
    List<ChangeNotifierProvider>? providers,
  }) async {
    if (size != null) {
      tester.binding.window.physicalSizeTestValue = size;
      tester.binding.window.devicePixelRatioTestValue = 1.0;
    }

    await tester.pumpWidget(
      createTestableWidget(
        child: widget,
        theme: theme,
        blocProviders: blocProviders,
        providers: providers,
      ),
    );

    await tester.pumpAndSettle();
  }

  /// Creates mock BLoC providers for testing
  static List<BlocProvider> createMockBlocProviders() {
    return [
      BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(authRepository: TestSetup.getMock<AuthRepository>() as MockAuthRepository),
      ),
      BlocProvider<UserBloc>(
        create: (_) => UserBloc(
          userRepository: TestSetup.getMock<UserRepository>() as MockUserRepository,
          authRepository: TestSetup.getMock<AuthRepository>() as MockAuthRepository,
        ),
      ),
      BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userProfileRepository: TestSetup.getMock<UserProfileRepository>() as MockUserProfileRepository,
          contentRepository: TestSetup.getMock<ContentRepository>() as MockContentRepository,
          userRepository: TestSetup.getMock<UserRepository>() as MockUserRepository,
        ),
      ),
      BlocProvider<SettingsBloc>(
        create: (_) => SettingsBloc(
          settingsRepository: TestSetup.getMock<SettingsRepository>() as MockSettingsRepository,
          authRepository: TestSetup.getMock<AuthRepository>() as MockAuthRepository,
          userProfileRepository: TestSetup.getMock<UserProfileRepository>() as MockUserProfileRepository,
        ),
      ),
      BlocProvider<MainScreenBloc>(
        create: (_) => MainScreenBloc(profileRepository: TestSetup.getMock<ProfileRepository>() as MockProfileRepository),
      ),
      BlocProvider<UserProfileBloc>(
        create: (_) => UserProfileBloc(userProfileRepository: TestSetup.getMock<UserProfileRepository>() as MockUserProfileRepository),
      ),
    ];
  }

  /// Creates a widget with mock BLoCs for testing
  static Future<void> pumpWidgetWithMockBlocs(
    WidgetTester tester,
    Widget widget, {
    Size? size,
    ThemeData? theme,
  }) async {
    await TestSetup.initMockDependencies();

    await pumpWidget(
      tester,
      widget,
      size: size,
      theme: theme,
      blocProviders: createMockBlocProviders(),
    );
  }

  /// Finds a widget by text and taps it
  static Future<void> tapByText(WidgetTester tester, String text) async {
    final finder = find.text(text);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Finds a widget by key and taps it
  static Future<void> tapByKey(WidgetTester tester, Key key) async {
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Finds a widget by type and taps it
  static Future<void> tapByType<T extends Widget>(WidgetTester tester) async {
    final finder = find.byType(T);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Enters text into a TextField/TextFormField
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    expect(finder, findsOneWidget);
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// Enters text by key
  static Future<void> enterTextByKey(WidgetTester tester, Key key, String text) async {
    final finder = find.byKey(key);
    await enterText(tester, finder, text);
  }

  /// Scrolls to make a widget visible
  static Future<void> scrollToWidget(WidgetTester tester, Finder finder) async {
    expect(finder, findsOneWidget);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  /// Drags a scrollable widget
  static Future<void> dragScrollable(
    WidgetTester tester,
    Finder scrollableFinder,
    Offset offset,
  ) async {
    expect(scrollableFinder, findsOneWidget);
    await tester.drag(scrollableFinder, offset);
    await tester.pumpAndSettle();
  }

  /// Waits for a specific condition to be met
  static Future<void> waitForCondition(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 5),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) async {
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      if (condition()) {
        return;
      }
      await tester.pump(pollInterval);
    }

    fail('Condition not met within timeout: $timeout');
  }

  /// Expects a widget to be present
  static void expectWidgetPresent(Finder finder, {String? reason}) {
    expect(finder, findsOneWidget, reason: reason);
  }

  /// Expects a widget to be absent
  static void expectWidgetAbsent(Finder finder, {String? reason}) {
    expect(finder, findsNothing, reason: reason);
  }

  /// Expects multiple widgets to be present
  static void expectWidgetsPresent(Finder finder, int count, {String? reason}) {
    expect(finder, findsNWidgets(count), reason: reason);
  }

  /// Expects text to be present
  static void expectTextPresent(String text, {String? reason}) {
    expect(find.text(text), findsOneWidget, reason: reason);
  }

  /// Expects text to be absent
  static void expectTextAbsent(String text, {String? reason}) {
    expect(find.text(text), findsNothing, reason: reason);
  }
}

/// Test widget builders for common scenarios
class TestWidgetBuilder {
  /// Builds a scaffold with app bar for testing
  static Widget scaffold({
    String? title,
    Widget? body,
    List<Widget>? actions,
    Widget? floatingActionButton,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Test App'),
        actions: actions,
      ),
      body: body ?? const Center(child: Text('Test Body')),
      floatingActionButton: floatingActionButton,
    );
  }

  /// Builds a list view for testing scrolling
  static Widget listView({
    int itemCount = 10,
    Widget Function(BuildContext, int)? itemBuilder,
  }) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder ?? (context, index) => ListTile(title: Text('Item $index')),
    );
  }

  /// Builds a grid view for testing
  static Widget gridView({
    int itemCount = 20,
    Widget Function(BuildContext, int)? itemBuilder,
  }) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder ?? (context, index) => Card(child: Center(child: Text('Item $index'))),
    );
  }

  /// Builds a form with text fields for testing
  static Widget form({
    Key? formKey,
    List<Widget>? fields,
  }) {
    return Form(
      key: formKey,
      child: Column(
        children: fields ?? [
          TextFormField(
            key: const Key('test_field_1'),
            decoration: const InputDecoration(labelText: 'Field 1'),
          ),
          TextFormField(
            key: const Key('test_field_2'),
            decoration: const InputDecoration(labelText: 'Field 2'),
          ),
        ],
      ),
    );
  }
}

/// Mock navigator observer for testing navigation
class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>?> pushedRoutes = [];
  final List<Route<dynamic>?> poppedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    poppedRoutes.add(route);
  }

  void reset() {
    pushedRoutes.clear();
    poppedRoutes.clear();
  }
}