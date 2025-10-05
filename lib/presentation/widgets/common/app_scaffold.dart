import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../domain/models/auth_user.dart';
import 'app_navigation_drawer.dart';

/// A reusable scaffold widget that provides consistent styling across the app
class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final EdgeInsetsGeometry? padding;
  final bool useSafeArea;
  final Widget? drawer;
  final bool showDrawer;

  const AppScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.padding,
    this.useSafeArea = true,
    this.drawer,
    this.showDrawer = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Authenticated state contains token and connected services, not user data
        // User data should be fetched separately if needed

        return Scaffold(
          backgroundColor: backgroundColor ?? Colors.black,
          appBar: appBar,
          drawer: drawer ?? (showDrawer ? AppNavigationDrawer(userProfile: null) : null),
          body: useSafeArea
              ? SafeArea(
                  child: padding != null
                      ? Padding(
                          padding: padding!,
                          child: body,
                        )
                      : body,
                )
              : padding != null
                  ? Padding(
                      padding: padding!,
                      child: body,
                    )
                  : body,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        );
      },
    );
  }
}