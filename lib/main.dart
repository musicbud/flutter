import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'injection.dart';
import 'debug/debug_dashboard.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/main/main_screen_bloc.dart';
import 'blocs/discover/discover_bloc.dart';
import 'blocs/library/library_bloc.dart';
import 'blocs/bud_matching/bud_matching_bloc.dart';
import 'blocs/comprehensive_chat/comprehensive_chat_bloc.dart';
import 'blocs/simple_content_bloc.dart';
import 'blocs/bud/bud_bloc.dart';
import 'blocs/content/content_bloc.dart';
import 'services/dynamic_theme_service.dart';
import 'services/dynamic_config_service.dart';
import 'presentation/pages/enhanced_main_screen.dart';

final sl = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up debug BLoC observer in debug mode
  if (kDebugMode) {
    Bloc.observer = DebugBlocObserver();
  }
  
  await initializeDependencies();
  
  // Initialize dynamic services
  await DynamicConfigService.instance.initialize();
  await DynamicThemeService.instance.initialize();
  
  runApp(const MusicBudApp());
}

class MusicBudApp extends StatefulWidget {
  const MusicBudApp({super.key});

  @override
  State<MusicBudApp> createState() => _MusicBudAppState();
}

class _MusicBudAppState extends State<MusicBudApp> {
  final DynamicThemeService _themeService = DynamicThemeService.instance;

  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    _themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => sl<UserBloc>(),
        ),
        BlocProvider<MainScreenBloc>(
          create: (context) => sl<MainScreenBloc>(),
        ),
        BlocProvider<DiscoverBloc>(
          create: (context) => sl<DiscoverBloc>(),
        ),
        BlocProvider<LibraryBloc>(
          create: (context) => sl<LibraryBloc>(),
        ),
        BlocProvider<BudMatchingBloc>(
          create: (context) => sl<BudMatchingBloc>(),
        ),
        BlocProvider<ComprehensiveChatBloc>(
          create: (context) => sl<ComprehensiveChatBloc>(),
        ),
        BlocProvider<SimpleContentBloc>(
          create: (context) => sl<SimpleContentBloc>(),
        ),
        BlocProvider<BudBloc>(
          create: (context) => sl<BudBloc>(),
        ),
        BlocProvider<ContentBloc>(
          create: (context) => sl<ContentBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'MusicBud',
        theme: _themeService.lightTheme,
        darkTheme: _themeService.darkTheme,
        themeMode: _themeService.themeMode,
        home: const MainApp(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          // Check auth on startup
          context.read<AuthBloc>().add(TokenRefreshRequested());
          return const SplashScreen();
        }
        if (state is AuthLoading) {
          return const SplashScreen();
        }
        if (state is Authenticated) {
          return const EnhancedMainScreen();
        }
        if (state is Unauthenticated || state is AuthError) {
          return const LoginPage();
        }
        return const SplashScreen();
      },
    );
  }
}

// Removed old MainAppScaffold - now using EnhancedMainScreen

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegister = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_isRegister) {
        context.read<AuthBloc>().add(RegisterRequested(
          username: _usernameController.text.trim(),
          email: '${_usernameController.text.trim()}@example.com',
          password: _passwordController.text,
        ));
      } else {
        context.read<AuthBloc>().add(LoginRequested(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to MusicBud')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter username' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: _isRegister,
                      onChanged: (v) => setState(() => _isRegister = v ?? false),
                    ),
                    const Text('Register instead of login'),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(_isRegister ? 'Register' : 'Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
