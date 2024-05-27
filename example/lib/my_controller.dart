import 'package:flutter/material.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';

class MyController {
  static final MyController _myController = MyController._internal();
  factory MyController() => _myController;
  MyController._internal();

  final text = ReactiveValueNotifier(TextEditingController(text: ""));
  final counter = ReactiveValueNotifier(0);
  final isDark = ReactiveValueNotifier(false);
  final lName = ReactiveValueNotifier(<String>[]);

  changeDarkMode() => isDark.value = !isDark.value;

  add() {
    var num = lName.value.length + 1;
    lName.value.add(num.toString());
    lName.notifyChanged();
  }

  sub() {
    var num = lName.value.length;
    lName.value.remove(num.toString());
    lName.notifyChanged();
  }
}
