import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final Set<String> _subscribers = {};

// Can't refer to listener while it is being declared, so we need this class
// to add a layer of indirection.
class _ListenerWrapper {
  void Function()? listener;
}

/// Extend [ValueNotifier] so that [Element] objects in the build tree can
/// respond to changes in the value.
extension ReactiveValueNotifier<T> on ValueNotifier<T> {
  /// Fetch the [value] of this [ValueNotifier], and subscribe the element
  /// that is currently being built (the [context]) to any changes in the
  /// value.
  T reactiveValue(BuildContext context) {
    final key = '$hashCode${context.hashCode}';

    if (_subscribers.contains(key)) {
      // there is already a listener for this value that hasn't executed yet
      return value;
    }

    _subscribers.add(key);

    final elementRef = WeakReference(context as Element);
    final listenerWrapper = _ListenerWrapper();
    listenerWrapper.listener = () {
      assert(
          SchedulerBinding.instance.schedulerPhase !=
              SchedulerPhase.persistentCallbacks,
          'Do not mutate state (by setting the value of the ValueNotifier '
          'that you are subscribed to) during a `build` method. If you need '
          'to schedule a value update after `build` has completed, use '
          '`SchedulerBinding.instance.scheduleTask(updateTask, Priority.idle)`, '
          '`SchedulerBinding.addPostFrameCallback(updateTask)`, '
          'or similar.');

      _subscribers.remove(key);

      // If the element has not been garbage collected (causing
      // `elementRef.target` to be null), or unmounted
      if (elementRef.target?.mounted ?? false) {
        // Mark the element as needing to be rebuilt
        elementRef.target!.markNeedsBuild();
      }
      // Remove the listener -- only listen to one change per `build`
      removeListener(listenerWrapper.listener!);
    };
    addListener(listenerWrapper.listener!);
    return value;
  }

  /// Use this method to notify listeners of deeper changes, e.g. when a value
  /// is added to or removed from a set which is stored in the value of a
  /// `ValueNotifier<Set<T>>`.
  void notifyChanged() {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    notifyListeners();
  }
}
