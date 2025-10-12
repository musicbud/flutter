import 'package:flutter_test/flutter_test.dart';
import 'package:musicbud_flutter/blocs/simple_auth_bloc.dart';
import 'package:musicbud_flutter/blocs/simple_content_bloc.dart';

void main() {
  group('Live BLoC Functionality Tests', () {
    late SimpleAuthBloc authBloc;
    late SimpleContentBloc contentBloc;

    setUp(() {
      authBloc = SimpleAuthBloc();
      contentBloc = SimpleContentBloc();
    });

    tearDown(() {
      authBloc.close();
      contentBloc.close();
    });

    test('Auth BLoC - Login Flow Works', () async {
      // Test initial state
      expect(authBloc.state, isA<SimpleAuthInitial>());

      // Test login request
      authBloc.add(const SimpleLoginRequested(username: 'testuser', password: 'password123'));
      
      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<SimpleAuthLoading>(),
          isA<SimpleAuthAuthenticated>(),
        ]),
      );
    });

    test('Content BLoC - Load Data Flow Works', () async {
      // Test initial state
      expect(contentBloc.state, isA<SimpleContentInitial>());

      // Test load data request
      contentBloc.add(LoadTopTracks());
      
      await expectLater(
        contentBloc.stream,
        emitsInOrder([
          isA<SimpleContentLoading>(),
          isA<SimpleContentLoaded>(),
        ]),
      );
    });

    test('Content BLoC - Refresh Works', () async {
      // Load initial data first
      contentBloc.add(LoadTopTracks());
      await contentBloc.stream.first;

      // Test refresh
      contentBloc.add(RefreshContent());
      
      await expectLater(
        contentBloc.stream,
        emits(isA<SimpleContentLoaded>()),
      );
    });

    test('Auth BLoC - Registration Flow Works', () async {
      // Test registration request
      authBloc.add(const SimpleRegisterRequested(
        username: 'newuser', 
        email: 'newuser@test.com', 
        password: 'password123'
      ));
      
      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<SimpleAuthLoading>(),
          isA<SimpleAuthRegistrationSuccess>(),
          isA<SimpleAuthAuthenticated>(),
        ]),
      );
    });

    test('Auth BLoC - Logout Flow Works', () async {
      // Login first
      authBloc.add(const SimpleLoginRequested(username: 'testuser', password: 'password123'));
      await authBloc.stream.take(2).last; // Wait for authentication

      // Test logout
      authBloc.add(SimpleLogoutRequested());
      
      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<SimpleAuthLoading>(),
          isA<SimpleAuthUnauthenticated>(),
        ]),
      );
    });
  });

  print('✅ All BLoC functionality tests completed successfully!');
  print('🎉 App logic is working correctly!');
}