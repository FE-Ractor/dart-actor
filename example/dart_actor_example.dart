import 'package:dart_actor/src/abstract_actor.dart';
import 'package:dart_actor/src/actor_system.dart';
import 'package:dart_actor/src/actor_ref.dart';

class WhoToGreet {
  String who;
  WhoToGreet(this.who);
}

class Greet {}

class Greeting {
  String message;
  Greeting(this.message);
}

class Replay {
  String message;
  Replay(this.message);
}

class Greeter extends AbstractActor {
  String _greeting = "";
  String _message;
  ActorRef _printer;
  Greeter(this._message, this._printer);

  @override
  preStart() {
    print('greeter start');
  }

  @override
  postStop() {
    print("greeter stop");
  }

  @override
  createReceive() {
    var receiveBuilder = this.receiveBuilder().match<WhoToGreet>((wtg) {
      print('WhoToGreet has been fire: ${wtg.who}');
      _greeting = this._message + ", " + wtg.who;
    }).match<Greet>((_) {
      this._printer.tell(new Greeting(this._greeting), this.getSelf());
    }).match<Replay>((replay) {
      print("receive message from printer: " + replay.message);
    });
    return receiveBuilder.build();
  }
}

class Printer extends AbstractActor {
  @override
  createReceive() {
    return this.receiveBuilder().match<Greeting>((greeting) {
      this.getSender().tell(new Replay(greeting.message), this.getSelf());
      print('hello');
    }).build();
  }
}

main() {
  var system = new ActorSystem("hello actor");

  var printerActor = system.actorOf(new Printer(), "printerActor");

  var howdyGreeter =
      system.actorOf(new Greeter("Howdy", printerActor), "howdyGreeter");

  howdyGreeter.tell(new WhoToGreet("actor"));
  howdyGreeter.tell(new Greet());

  howdyGreeter.tell(new WhoToGreet("lightbend"));

  system.broadcast(new Greet());

  system.stop(howdyGreeter);

  howdyGreeter.tell(new WhoToGreet("sakura"));
  howdyGreeter.tell(new Greet());

  system.terminal();
}
