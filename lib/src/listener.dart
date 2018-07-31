//import 'package:dart_actor/dart_actor.dart';

class Listener<T> {
  T message;
  dynamic callback;

  Listener(this.message, this.callback);
}
