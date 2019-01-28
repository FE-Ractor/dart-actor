import 'package:dart_actor/src/listener.dart';
import "package:dart_actor/src/actor_receive.dart";

class ActorReceiveBuilder {
  List<Listener> _listeners = new List();

  ActorReceiveBuilder match<T>(dynamic Function(T) callback) {
    if (T == dynamic) {
      _listeners.add(new Listener((value) {
        return callback(value);
      }));
    } else {
      _listeners.add(new Listener((value) {
        return callback(value);
      }, T));
    }
    return this;
  }

  ActorReceiveBuilder matchAny(dynamic Function(Object) callback) {
    _listeners.add(new Listener((value) {
      return callback(value);
    }));
    return this;
  }

  ActorReceive build() {
    return new ActorReceive(_listeners);
  }
}
