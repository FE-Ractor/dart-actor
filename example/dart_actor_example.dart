import 'package:dart_actor/src/actor.dart';
import 'package:dart_actor/src/actor-receive.dart';
import 'package:dart_actor/src/actor-system.dart';
import 'package:dart_actor/src/actor-ref.dart';

class WhoToGreet {
  String who;
  WhoToGreet(this.who);
}

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
    var receiveBuilder = this
        .receiveBuilder()
        .match(WhoToGreet, _WhoToGreetCallback)
        .match(Replay, _ReplayCallback);
    return receiveBuilder.build();
  }

  _WhoToGreetCallback(WhoToGreet wtg) {
    print('WhoToGreet is been fire: ${wtg.who}');
    _greeting = this._message + ", " + wtg.who;
  }

  _ReplayCallback(Replay replay) {
    print("receive message from printer: " + replay.message);
  }
}

class Printer extends AbstractActor {
  @override
  preStart() {
    print("printer start");
  }

  @override
  postStop() {
    print("printer stop");
  }

  @override
  ActorReceive createReceive() {
    var receiveBuilder = this.receiveBuilder().match(Greeting, _callback);
    return receiveBuilder.build();
  }

  _callback(Greeting greeting) {
    print('hello');
  }
}

main() {
  var system = new ActorSystem("hello actor");

  var printerActor = system.actorOf(new Printer(), "printerActor");

  var howdyGreeter =
      system.actorOf(new Greeter("Howdy", printerActor), "howdyGreeter");

  howdyGreeter.tell(new WhoToGreet("actor"));
//  howdyGreeter.tell(new G)

  howdyGreeter.tell(new WhoToGreet("lightbend"));

//  system.tell()

  system.stop(howdyGreeter);

  howdyGreeter.tell(new WhoToGreet("sakura"));
//  howdyGreeter.tell()

  system.terminal();
}
