import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    const MaterialApp(
      title: "Application",
      home: HomeView(),
    ),
  );
}

final counter = ValueNotifier<int>(0);

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '${counter.reactiveValue(context)}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value++;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.plus_one_outlined),
      ),
    );
  }
}
