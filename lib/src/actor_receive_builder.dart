import 'package:dart_actor/src/listener.dart';
import "package:dart_actor/src/actor_receive.dart";

class ActorReceiveBuilder {
  List<Listener> _listeners = new List();

  static ActorReceiveBuilder create() {
    return ActorReceiveBuilder();
  }

  ActorReceiveBuilder match<T>(dynamic Function(T) callback) {
    if (T == dynamic) {
      this.matchAny(callback);
    } else {
      _listeners.add(new Listener(ListenerType.match, (value) {
        return callback(value);
      }, T));
    }
    return this;
  }

  ActorReceiveBuilder matchAny(dynamic Function(dynamic) callback) {
    _listeners.add(new Listener(ListenerType.match, (value) {
      return callback(value);
    }));
    return this;
  }

  /// Ask pattern. It's another way to let you communicate with Store.
  /// ```dart
  /// anyStore.ask(Message())
  /// 
  /// .answer<Message>((message) {
  ///   return 'reply anything as you like.';
  /// })
  /// ```
  ActorReceiveBuilder answer<T>(Future<dynamic> Function(T) callback) {
    _listeners.add(new Listener(ListenerType.answer, (value) {
      return callback(value);
    }));
    return this;
  }

  ActorReceive build() {
    return new ActorReceive(_listeners);
  }
}
