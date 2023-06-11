# `flutter_reactive_value` library

This library provides a mechanism for causing a UI to reactively update in response to changes in underlying values in your data model.

This is the simplest possible state management / reactive UI update solution for Flutter by far, reducing boilerplate compared to all the insanely complex [state management approaches](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options) in common use.

## Usage

(1) Add a dependency upon `flutter_reactive_value` in your `pubspec.yaml` (replace `any` with the latest version, if you want to control the version), then run `flutter pub get`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_reactive_value: any
```

(2) Import the package in your Flutter project:

```dart
import 'package:flutter_reactive_value/flutter_reactive_value.dart'
```

(3) Use the standard Flutter `ValueNotifier<T>` mechanism to declare any values you want your UI to listen for changes to (probably host these inside the `State` object of the appropriate `StatefulWidget`):

```dart
final counter = ValueNotifier(0);
```

(4) Build your UI the standard way, using a `Widget` hierarchy, and anywhere you want to use the value and respond to future changes in the value by updating the UI, instead of using the `ValueNotifier.value` getter method, use `ValueNotifier.reactiveValue(BuildContext)`:

```dart
Text('The current count is ${counter.reactiveValue(context)}')
```

Now when `counter.value` changes, the enclosing widget will be scheduled for rebuilding.

(The only place you're not allowed to update `counter.value` is the `build` method of a widget, since state changes are disallowed in `build` methods.)

That's all there is to it!

## The code

The `flutter_reactive_value` mechanism is extremely simple. [See the code here.](https://github.com/lukehutch/flutter_reactive_value/blob/main/lib/src/reactive_value_notifier.dart)

## Author

`flutter_reactive_value` was written by Luke Hutchison, and is released under the MIT license.