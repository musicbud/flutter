/// Comprehensive Widget Tests
/// 
/// Tests for all major widgets and screens in the app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:musicbud_flutter/blocs/auth/auth_bloc.dart';
import 'package:musicbud_flutter/widgets/bloc_form_widget.dart';
import 'package:musicbud_flutter/widgets/bloc_list_widget.dart';
import '../test_config.dart';

// Generate mocks
@GenerateMocks([AuthBloc])
import 'comprehensive_widget_test.mocks.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('BlocFormWidget renders correctly', (tester) async {
      TestLogger.log('Testing BlocFormWidget rendering');
      
      final mockBloc = MockAuthBloc();
      
      when(mockBloc.state).thenReturn(AuthInitial());
      when(mockBloc.stream).thenAnswer((_) => Stream.value(AuthInitial()));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockBloc,
            child: BlocFormWidget<AuthBloc, AuthState>(
              formKey: GlobalKey<FormState>(),
              isLoadingSelector: (state) => state is AuthLoading,
              onSubmit: (bloc) {
                bloc.add(const LoginRequested(
                  username: TestConfig.testUsername,
                  password: TestConfig.testPassword,
                ));
              },
              formBuilder: (context, bloc, formKey) {
                return Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Username'),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      
      TestLogger.logSuccess('BlocFormWidget rendered successfully');
    });

    testWidgets('Form shows loading indicator when state is loading', (tester) async {
      TestLogger.log('Testing loading state');
      
      final mockBloc = MockAuthBloc();
      when(mockBloc.state).thenReturn(AuthLoading());
      when(mockBloc.stream).thenAnswer((_) => Stream.value(AuthLoading()));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockBloc,
            child: BlocFormWidget<AuthBloc, AuthState>(
              formKey: GlobalKey<FormState>(),
              isLoadingSelector: (state) => state is AuthLoading,
              onSubmit: (bloc) {},
              formBuilder: (context, bloc, formKey) {
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      TestLogger.logSuccess('Loading indicator displayed correctly');
    });

    testWidgets('TextFormField accepts input', (tester) async {
      TestLogger.log('Testing text input');
      
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Test Field'),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test input');
      expect(controller.text, 'test input');
      
      TestLogger.logSuccess('Text input works correctly');
    });

    testWidgets('Button tap triggers callback', (tester) async {
      TestLogger.log('Testing button tap');
      
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {
                tapped = true;
              },
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      expect(tapped, true);
      
      TestLogger.logSuccess('Button tap handled correctly');
    });

    testWidgets('Form validation shows error messages', (tester) async {
      TestLogger.log('Testing form validation');
      
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Required Field'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('This field is required'), findsOneWidget);
      
      TestLogger.logSuccess('Validation error displayed correctly');
    });

    testWidgets('ListView scrolls correctly', (tester) async {
      TestLogger.log('Testing ListView scrolling');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 50'), findsNothing);

      await tester.drag(find.byType(ListView), const Offset(0, -5000));
      await tester.pumpAndSettle();

      expect(find.text('Item 0'), findsNothing);
      expect(find.text('Item 90'), findsWidgets);
      
      TestLogger.logSuccess('ListView scrolling works correctly');
    });

    testWidgets('TabBar switches tabs correctly', (tester) async {
      TestLogger.log('Testing TabBar');
      
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Tab 1'),
                    Tab(text: 'Tab 2'),
                    Tab(text: 'Tab 3'),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [
                  Center(child: Text('Content 1')),
                  Center(child: Text('Content 2')),
                  Center(child: Text('Content 3')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Content 2'), findsOneWidget);
      
      TestLogger.logSuccess('TabBar works correctly');
    });

    testWidgets('Drawer opens and closes', (tester) async {
      TestLogger.log('Testing Drawer');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Test')),
            drawer: Drawer(
              child: ListView(
                children: const [
                  ListTile(title: Text('Drawer Item')),
                ],
              ),
            ),
            body: const Center(child: Text('Main Content')),
          ),
        ),
      );

      expect(find.text('Drawer Item'), findsNothing);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('Drawer Item'), findsOneWidget);
      
      TestLogger.logSuccess('Drawer works correctly');
    });

    testWidgets('SnackBar shows and dismisses', (tester) async {
      TestLogger.log('Testing SnackBar');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Test Message')),
                    );
                  },
                  child: const Text('Show SnackBar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show SnackBar'));
      await tester.pump();

      expect(find.text('Test Message'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      expect(find.text('Test Message'), findsNothing);
      
      TestLogger.logSuccess('SnackBar works correctly');
    });

    testWidgets('Dialog shows and dismisses', (tester) async {
      TestLogger.log('Testing Dialog');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Test Dialog'),
                        content: const Text('Dialog Content'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test Dialog'), findsOneWidget);
      expect(find.text('Dialog Content'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Test Dialog'), findsNothing);
      
      TestLogger.logSuccess('Dialog works correctly');
    });

    testWidgets('RefreshIndicator triggers refresh callback', (tester) async {
      TestLogger.log('Testing RefreshIndicator');
      
      var refreshed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                refreshed = true;
                await Future.delayed(TestConfig.shortDelay);
              },
              child: ListView(
                children: const [
                  ListTile(title: Text('Pull to refresh')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.drag(find.text('Pull to refresh'), const Offset(0, 300));
      await tester.pump();
      await tester.pump(TestConfig.shortDelay);

      expect(refreshed, true);
      
      TestLogger.logSuccess('RefreshIndicator works correctly');
    });

    testWidgets('Image placeholder shows before loading', (tester) async {
      TestLogger.log('Testing Image placeholder');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FadeInImage(
              placeholder: const AssetImage('assets/images/placeholder.png'),
              image: const NetworkImage('https://example.com/image.jpg'),
              imageErrorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
          ),
        ),
      );

      // Should show error icon since network image will fail in test
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.error), findsOneWidget);
      
      TestLogger.logSuccess('Image error handling works correctly');
    });

    testWidgets('Checkbox toggles state', (tester) async {
      TestLogger.log('Testing Checkbox');
      
      var isChecked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      
      TestLogger.logSuccess('Checkbox works correctly');
    });

    testWidgets('Switch toggles state', (tester) async {
      TestLogger.log('Testing Switch');
      
      var isSwitched = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      expect(tester.widget<Switch>(find.byType(Switch)).value, false);

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(tester.widget<Switch>(find.byType(Switch)).value, true);
      
      TestLogger.logSuccess('Switch works correctly');
    });

    testWidgets('Slider changes value', (tester) async {
      TestLogger.log('Testing Slider');
      
      var sliderValue = 0.5;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Slider(
                  value: sliderValue,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      expect(tester.widget<Slider>(find.byType(Slider)).value, 0.5);

      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pump();

      expect(tester.widget<Slider>(find.byType(Slider)).value, greaterThan(0.5));
      
      TestLogger.logSuccess('Slider works correctly');
    });

    testWidgets('BottomNavigationBar switches pages', (tester) async {
      TestLogger.log('Testing BottomNavigationBar');
      
      var selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: [
                  const Center(child: Text('Page 1')),
                  const Center(child: Text('Page 2')),
                  const Center(child: Text('Page 3')),
                ][selectedIndex],
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                  ],
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Page 1'), findsOneWidget);
      expect(find.text('Page 2'), findsNothing);

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      expect(find.text('Page 1'), findsNothing);
      expect(find.text('Page 2'), findsOneWidget);
      
      TestLogger.logSuccess('BottomNavigationBar works correctly');
    });
  });
}
