import 'package:dart_actor/dart_actor.dart';

abstract class AbstractActor {
  ActorContext actorContext;

  ActorReceive createReceive();

  static void getSelf() {
    // @todo
  }

  
}

class Actor extends AbstractActor {

  @override
  ActorReceive createReceive() {
    return new ActorReceive([]);
  }
}
