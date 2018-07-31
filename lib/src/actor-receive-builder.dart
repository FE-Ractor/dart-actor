import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/src/listener.dart';

class ActorReceiveBuilder {
  List<Listener> _listeners = new List();

  ActorReceiveBuilder match<T>(T message, dynamic callback) {
    _listeners.add(new Listener(message, callback));
    return this;
  }

  ActorReceive build() {
    return new ActorReceive(_listeners);
  }
}
