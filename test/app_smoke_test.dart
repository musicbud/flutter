import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:musicbud_flutter/main.dart';
import 'package:musicbud_flutter/blocs/simple_auth_bloc.dart';
import 'package:musicbud_flutter/blocs/simple_content_bloc.dart';

void main() {
  group('App Smoke Tests', () {
    testWidgets('App builds without errors', (WidgetTester tester) async {
      // Just test that the app can be built without errors
      await tester.pumpWidget(const MusicBudApp());
      
      // The app should build successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('BLoC providers are accessible', (WidgetTester tester) async {
      await tester.pumpWidget(const MusicBudApp());
      
      // Should be able to read the BLoCs from context
      final context = tester.element(find.byType(MaterialApp).first);
      
      // Should not throw when accessing these BLoCs
      expect(() => context.read<SimpleAuthBloc>(), returnsNormally);
      expect(() => context.read<SimpleContentBloc>(), returnsNormally);
    });
  });
}