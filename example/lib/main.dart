import 'package:flutter/material.dart';
import 'package:flutter_reactive_value_example/my_controller.dart';
import 'package:flutter_reactive_value_example/page_1.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final c = MyController();

    return Builder(
      builder: (cc) {
        return MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const Page1(),
          themeMode:
              c.isDark.reactiveValue(cc) ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
