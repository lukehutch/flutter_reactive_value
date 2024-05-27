import 'package:flutter/material.dart';
import 'package:flutter_reactive_value_example/page_2.dart';

import 'my_controller.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    final c = MyController();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: c.text.value,
              onChanged: (_) => c.text.notifyChanged(),
            ),
          ),
          Builder(
            builder: (cc) => Text(
              c.text.reactiveValue(cc).text,
            ),
          ),
          Builder(
            builder: (cc) => Switch(
                value: c.isDark.reactiveValue(cc),
                onChanged: (_) {
                  c.changeDarkMode();
                }),
          ),
          FilledButton(
              onPressed: () {
                c.counter.value++;
              },
              child: const Text("+ int")),
          FilledButton(
              onPressed: () {
                c.counter.value--;
              },
              child: const Text("- int")),
          Builder(
            builder: (cc) => Text(
              c.counter.reactiveValue(cc).toString(),
            ),
          ),
          FilledButton(
              onPressed: () {
                c.add();
              },
              child: const Text("add list")),
          FilledButton(
              onPressed: () {
                c.sub();
              },
              child: const Text("sub list")),
          Builder(
            builder: (cc) => Text(
              c.lName.reactiveValue(cc).toString(),
            ),
          ),
          FilledButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Page2(),
                    ));
              },
              child: const Text("goto page 2")),
        ],
      ),
    );
  }
}
