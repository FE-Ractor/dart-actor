import 'package:dart_actor/src/actor.dart';
import 'package:dart_actor/src/actor-receive.dart';

class Actor extends AbstractActor {

  @override
  ActorReceive createReceive() {
    return new ActorReceive([]);
  }
}


main() {
  var awesome = new Actor();
}
