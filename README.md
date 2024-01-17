# The `flutter_reactive_value` library

This library provides a mechanism for causing a UI to reactively update in response to changes in underlying values in your data model.

This is the simplest possible state management / reactive UI update solution for Flutter, by far, reducing boilerplate compared to all the other insanely complex [state management approaches](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options) currently available.

The closest thing to `flutter_reactive_value` is [`ValueListenableBuilder`](https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html). `flutter_reactive_value` provides the same basic capabilities as `ValueListenableBuilder`, but with much less syntactic overhead (i.e. you could think of `flutter_reactive_value` as syntactic sugar). `ValueListenableBuilder` may work better if your reactive widget has a child element that is complex and non-reactive, because it takes a `child` parameter for any child widget that is not affected by changes to the `ValueNotifier`'s value.

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

(3) Use `ReactiveValueNotifier<T>` rather than the standard Flutter [`ValueNotifier<T>`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) to declare any values you want your UI to listen for changes to:

```dart
final counter = ReactiveValueNotifier(0);
```

(4) Build your UI the standard way, using a `Widget` hierarchy, and anywhere you want to use the value and respond to future changes in the value by updating the UI, instead of using the usual `ValueNotifier.value` getter method, use `ReactiveValueNotifier.reactiveValue(BuildContext)`:

```dart
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          // Read value, and subscribe to changes:
          'The count is: ${counter.reactiveValue(context)}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Update value:
          counter.value++;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.plus_one_outlined),
      ),
    );
  }
}
```

Now whenever `counter.value` changes (here using `counter.value++` in the `onPressed` handler), the enclosing widget (here `HomeView`), from which the `BuildContext` was obtained, will be scheduled for rebuilding.

(The only place you're not allowed to update `counter.value` is the `build` method of a widget, since state changes are disallowed in `build` methods.)

There is no need to dispose the `ValueNotifier` listener -- it is automatically removed whenever the value changes (and it is added back whenever the `build` method is called, during a rebuild).

That's all there is to it, at least for simple usage!

## Optimizing UI updates

If you have a deep nested tree of `Widget` constructor calls within a single `StatelessWidget` or `StatefulWidget`, then you probably don't want to rebuild the whole `Widget` subtree each time only one value changes. You can limit the region that is updated by using `Builder` to introduce a new `BuildContext` right above the `reactiveValue(context)` call.

Before:

```dart
// ...
Container(
  child: Text('${counter.reactiveValue(context)}'),
),
// ...
```

After:

```dart
// ...
Container(
  child: Builder(
    builder: (subContext) => Text('${counter.reactiveValue(subContext)}'),
  ),
),
// ...
```

## Notifying listeners of deeper changes

If you try to wrap a collection or object in a `ValueNotifier`, e.g. to track a set of values using `ValueNotifier<Set<T>>`, then modifying fields, or adding or removing values from the collection or object will not notify the listeners of the `ValueNotifier` that the value has changed (because the value itself has not changed). In this case you can call the extension method `notifyChanged()` to manually call the listeners. For example:

```dart
final tags = ReactiveValueNotifier(<String>{});

void addOrRemoveTag(String tag, bool add) {
  if ((add && tags.value.add(tag)) || (!add && tags.value.remove(tag))) {
    tags.notifyChanged();
  }
}
```

## Pro-tip: persistence

See my other library, [`flutter_persistent_value_notifier`](https://github.com/lukehutch/flutter_persistent_value_notifier), to enable persistent state in your app!

## Author

`flutter_reactive_value` was written by Luke Hutchison, and is released under the MIT license.