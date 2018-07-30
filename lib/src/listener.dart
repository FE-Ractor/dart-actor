//import 'package:dart_actor/dart_actor.dart';

abstract class Listener {
  Function message;
  dynamic callback(dynamic value);
}
