import 'package:dart_actor/src/listener.dart';
import 'package:dart_actor/src/message.dart';

class ActorReceiveBuilder {
  List<Listener> _listeners = new List();

  ActorReceiveBuilder match<T extends Message>(T message, dynamic callback) {
    _listeners.add(new Listener<T>(message, callback));
    return this;
  }

  ActorReceive build() {
    return new ActorReceive(_listeners);
  }
}
