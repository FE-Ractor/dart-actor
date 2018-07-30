import 'package:dart_actor/dart_actor.dart';

class ActorReceiveBuilder {
  List<Map<String, dynamic>> listener;

  ActorReceiveBuilder match<T>(String message, dynamic callback) {
    listener.add({ message: message, callback: callback });
    return this;
  }
}
