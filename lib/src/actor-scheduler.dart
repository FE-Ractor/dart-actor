import 'dart:async';
import 'package:event_bus/event_bus.dart';

import 'package:dart_actor/src/listener.dart';
import 'package:dart_actor/src/actor.dart';

class ActorScheduler {
  Listener defaultListeners;
  EventBus eventStream;
  Object event;
  List<Listener> listeners;
  AbstractActor owner;
  StreamSubscription _streamSubscription;

  ActorScheduler(this.eventStream, this.event, this.listeners, this.owner) {
//    var reg = new RegExp(r"(/\//g)");
//    this.event = this.event.replaceAll(reg, ".");

    this.defaultListeners =
       listeners.length > 0 ? listeners.firstWhere((listener) => listener.message != null) : null;
  }

  callback(Object value) {
    var listener = listeners.length > 0 ? this.listeners.firstWhere(
        (Listener listener) => listener.message != null && value is Function) : null;

    try {
      if (listener != null) {
        return listener.callback(value);
      }
      return this.defaultListeners != null &&
          this.defaultListeners.callback(value);
    } catch (e) {
      this.owner.postError(e);
    }
  }

  bool cancel() {
    _streamSubscription != null ? _streamSubscription.cancel() : null;
    return true;
  }

  bool isCancelled() {
  return _streamSubscription.isPaused;
  }

  void start() {
    _streamSubscription = this.eventStream.on(event).listen(callback);
  }

  void restart() {
    cancel();
    start();
  }

  void replaceLiteners(List<Listener> listeners) {
    this.listeners = listeners;
    this.defaultListeners =
        this.listeners.firstWhere((listener) => listener.message != null);
  }
}
