import "package:flutter/material.dart";
import "../../constants/app_constants.dart";

class ModernMusicPage extends StatelessWidget {
  const ModernMusicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music"),
      ),
      body: const Center(
        child: Text("Music Page - Coming Soon"),
      ),
    );
  }
}
