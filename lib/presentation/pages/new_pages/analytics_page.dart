import "package:flutter/material.dart";
import "../../constants/app_constants.dart";

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
      ),
      body: const Center(
        child: Text("Analytics Page - Coming Soon"),
      ),
    );
  }
}
