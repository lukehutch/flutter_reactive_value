import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class _ListenerWrapper<T> {
  void Function()? listener;
}

extension ReactiveValueNotifier<T> on ValueNotifier<T> {
  T reactiveValue(BuildContext context) {
    final elementRef = WeakReference(context as Element);
    // Can't refer to listener while it is being declared, so need to add
    // a layer of indirection.
    final listenerWrapper = _ListenerWrapper<void Function()>();
    listenerWrapper.listener = () {
      assert(
          SchedulerBinding.instance.schedulerPhase !=
              SchedulerPhase.persistentCallbacks,
          'Do not mutate state (by setting the value of the ValueNotifier '
          'that you are subscribed to) during a `build` method. If you need '
          'to schedule the value to update after `build` has completed, use '
          '`SchedulerBinding.instance.scheduleTask(updateTask, Priority.idle)` '
          'or similar.');
      // If the element has not been garbage collected, mark the element
      // as needing to be rebuilt
      elementRef.target?.markNeedsBuild();
      // Remove the listener -- only listen to one change per `build`
      removeListener(listenerWrapper.listener!);
    };
    addListener(listenerWrapper.listener!);
    return value;
  }
}
