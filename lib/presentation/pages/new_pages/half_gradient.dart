import 'package:flutter/material.dart';
void main(List<String> args) {
  runApp(const MyApp());  

}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Container(color: const Color.fromARGB(105, 255, 255, 255),
          child: const Center(
            child: SizedBox(
              width: 400,
              height: 300,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(tileMode: TileMode.clamp,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(0, 255, 255, 255),
                      Color.fromARGB(0, 255, 255, 255),
                      Color.fromARGB(255, 0, 0, 0),
                      Color.fromARGB(255, 0, 0, 0),
                    ],
                  ),
                ),
              )),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
  

