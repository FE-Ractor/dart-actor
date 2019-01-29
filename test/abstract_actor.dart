//import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/dart_actor.dart';
import "package:test/test.dart";

class Action {
  String message;
  Action(this.message);
}

class TestMatch extends AbstractActor {
  createReceive() {
    return this.receiveBuilder().match<Action>((action) {
      expect(action.message, "hello");
    }).build();
  }
}

class TestAny extends AbstractActor {
  createReceive() {
    return this.receiveBuilder().match((action) {
      expect(action.message, "hello");
    }).build();
  }
}

void main() {
  test("match", () {
    var system = ActorSystem("testSystem");
    system.actorOf(TestMatch());
    system.broadcast(Action("hello"));
  });

  test("matchAny", () {
    var system = ActorSystem("testSystem");
    system.actorOf(TestMatch());
    system.broadcast(Action("hello"));
  });
}
