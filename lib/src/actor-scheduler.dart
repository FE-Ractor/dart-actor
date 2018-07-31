import 'dart:async';
import 'package:dart_event_emitter/dart_event_emitter.dart';

import 'package:dart_actor/src/listener.dart';
import 'package:dart_actor/src/actor.dart';
import 'package:dart_actor/src/message.dart';

class ActorScheduler {
  Listener defaultListeners;
  EventEmitter eventStream;
  Object event;
  List<Listener> listeners;
  AbstractActor owner;
  StreamSubscription _streamSubscription;

  ActorScheduler(this.eventStream, this.event, this.listeners, this.owner) {
//    var reg = new RegExp(r"(/\//g)");
//    this.event = this.event.replaceAll(reg, ".");

    this.defaultListeners =
       listeners.length > 0 ? listeners.firstWhere((Listener listener) => listener.message != null) : null;
  }

  callback(Object value) {
    var listener = this.listeners.firstWhere(
        (Listener _listener) => _listener.message != null && value is listener.message) ?? null;
//    typedef Klass = listener.message;
//    print('listener.message: ${value is Klass}');
    try {
      if (listener != null) {
        print(listener.callback);
        return listener.callback(value);
      }
      return this.defaultListeners != null &&
          this.defaultListeners.callback(value);
    } catch (e) {
      this.owner.postError(e);
    }
  }

  bool cancel() {
    eventStream.removeListener(event, callback);
    return true;
  }

  bool isCancelled() {
    return eventStream.listeners(event).length == 0;
  }

  void start() {
    this.eventStream.on(event, callback);
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
