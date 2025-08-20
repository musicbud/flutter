import 'package:flutter/material.dart';

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.black,
      appBar: appBar,
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
  }
}