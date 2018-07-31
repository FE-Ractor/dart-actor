import 'package:dart_actor/src/actor.dart';
import 'package:dart_actor/src/actor-receive.dart';

class RootActor extends AbstractActor {
  ActorReceive createReceive() {
    return this.receiveBuilder().build();
  }

  @override
  postStop(){
    print("root actor stop");
  }

  @override
  preStart(){
    print("root actor start");
  }
}
