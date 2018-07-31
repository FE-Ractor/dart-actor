import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/src/listener.dart';

class ActorReceiveBuilder {
  List<Listener> listeners;

  ActorReceiveBuilder match<T>(T message, dynamic callback) {
    listeners.add({ message: message, callback: callback } as Listener);
    return this;
  }

  ActorReceive build() {
    return new ActorReceive(listeners);
  }
}
