### 2.0.0

Fix memory leak (listeners were being added with every build). This required converting `ReactiveValueNotifier` from an extension to a subclass, because it needed an extra private field. (#5)

### 1.0.4

Specify correct minimum Dart and Flutter versions (fixes #2).

### 1.0.3

Update docs only (so that pub.dev is updated).

### 1.0.2

Check if `mounted` before calling `markNeedsBuild()`

### 1.0.1

Add `notifyChanged` method.

### 1.0.0

First pub.dev release.