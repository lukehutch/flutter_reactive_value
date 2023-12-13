import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Can't refer to listener while it is being declared, so we need this class
// to add a layer of indirection.
class _ListenerWrapper {
  void Function()? listener;
}

/// Extend [ValueNotifier] so that [Element] objects in the build tree can
/// respond to changes in the value.
class ReactiveValueNotifier<T> extends ValueNotifier<T> {
  ReactiveValueNotifier(super.value);

  /// An Expando mapping from `Element` objects to `true`, if the `Element`
  ///  is subscribed to this `ValueNotifier`.
  final _subscribedElements = Expando<bool>();

  /// Fetch the [value] of this [ValueNotifier], and subscribe the element
  /// that is currently being built (the [context]) to any changes in the
  /// value.
  T reactiveValue(BuildContext context) {
    final element = context as Element;
    // If element is already subscribed, return the current value without
    // subscribing again
    if (_subscribedElements[element] == true) {
      return value;
    }
    // Add a weak reference to the element to the Expando of subscribed
    // elements
    _subscribedElements[element] = true;

    // Create a weak reference to the element
    final elementRef = WeakReference(element);

    final listenerWrapper = _ListenerWrapper();
    listenerWrapper.listener = () {
      // State is not supposed to be mutated during `build`
      assert(
          SchedulerBinding.instance.schedulerPhase !=
              SchedulerPhase.persistentCallbacks,
          'Do not mutate state (by setting the value of the ValueNotifier '
          'that you are subscribed to) during a `build` method. If you need '
          'to schedule a value update after `build` has completed, use '
          'SchedulerBinding.instance.scheduleTask(updateTask, Priority.idle), '
          'SchedulerBinding.addPostFrameCallback(updateTask), '
          'or similar.');
      // If the element has not been garbage collected (causing
      // `elementRef.target` to be null), or unmounted
      final elementRefTarget = elementRef.target;
      if (elementRefTarget != null) {
        if (elementRefTarget.mounted) {
          // Then mark the element as needing to be rebuilt
          elementRefTarget.markNeedsBuild();
        }
        // Remove the element from the Expando of subscribed elements
        _subscribedElements[elementRefTarget] = null;
      }
      // Remove the listener -- only listen to one change per build
      // (each subsequent build will resubscribe)
      removeListener(listenerWrapper.listener!);
    };
    // Listen to changes to the ReactiveValue
    addListener(listenerWrapper.listener!);
    // Return the current value
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
