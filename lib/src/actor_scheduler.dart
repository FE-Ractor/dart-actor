import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:dart_actor/src/listener.dart';
import 'package:dart_actor/src/abstract_actor.dart';

class ActorScheduler {
  Listener defaultListener;
  EventBus eventBus;
  Object event;
  List<Listener> listeners;
  AbstractActor owner;

  StreamSubscription subscription;

  ActorScheduler(this.eventBus, this.event, this.listeners, this.owner) {}

  callback(dynamic message) {
    final listener = this.listeners.firstWhere(
        (Listener listener) => message.runtimeType == listener.message,
        orElse: () => null);
    try {
      if (listener != null) {
        return listener.callback(message);
      }

      if (this.defaultListener != null) {
        return this.defaultListener.callback(message);
      }
    } catch (e) {
      this.owner.postError(e);
    }
  }

  void cancel() {
    subscription.cancel();
  }

  void start() {
    subscription = this.eventBus.on().listen(callback);
  }

  void restart() {
    cancel();
    start();
  }

  void replaceLiteners(List<Listener> listeners) {
    this.listeners = listeners;
    this.defaultListener = listeners
        .firstWhere((listener) => listener.message == null, orElse: () => null);
  }
}
