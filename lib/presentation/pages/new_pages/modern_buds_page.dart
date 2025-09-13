import "package:flutter/material.dart";
import "../../constants/app_constants.dart";

class ModernBudsPage extends StatelessWidget {
  const ModernBudsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buds"),
      ),
      body: const Center(
        child: Text("Buds Page - Coming Soon"),
      ),
    );
  }
}
