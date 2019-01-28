import 'package:dart_actor/dart_actor.dart';

class Foo {}

class Shout {
  String message;
  Shout(this.message);
}

class EchoActor extends AbstractActor {
  @override
  ActorReceive createReceive() {
    return this.receiveBuilder().match<Shout>((shout) {
      print("received message: " + shout.message);
    })
    .match((obj) {
      print("received unmatched message: " + obj.toString());
    })
    .build();
  }
}

void main() {
  var system = ActorSystem("echo system");

  system.actorOf(EchoActor());

  system.broadcast(Shout("hello"));

  system.broadcast(Foo());
}
