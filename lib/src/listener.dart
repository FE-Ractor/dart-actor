import 'package:dart_actor/src/message.dart';

class Listener<T> {
  Message message;
  dynamic callback;

  Listener(this.message, this.callback);
}
