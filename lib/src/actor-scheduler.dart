import 'package:event_bus/event_bus.dart';

import 'package:dart_actor/src/listener.dart';
import 'package:dart_actor/src/actor.dart';

class ActorScheduler {
  Listener defaultListeners;
  EventBus eventStream;
  String event;
  List<Listener> listeners;
  AbstractActor owner;

  ActorScheduler(this.eventStream, this.event, this.listeners, this.owner) {
    var reg = new RegExp(r"(/\//g)");
    this.event = this.event.replaceAll(reg, ".");

    this.defaultListeners =
        this.listeners.firstWhere((listener) => listener.message != null);
  }

  callback(Object value) {
    var listener = this.listeners.firstWhere(
        (Listener listener) => listener.message != null && value is Function);

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

  void replaceLiteners(List<Listener> listeners) {
    this.listeners = listeners;
    this.defaultListeners =
        this.listeners.firstWhere((listener) => listener.message != null);
  }
}
