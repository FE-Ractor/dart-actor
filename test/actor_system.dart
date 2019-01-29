//import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/dart_actor.dart';
import "package:test/test.dart";

class Action {
  String message;
  Action(this.message);
}

class TestAny extends AbstractActor {
  preStart() {
    this.context.system.eventBus.on<Action>().listen((action) {
      expect(action.message, "hello");
    });
  }

  createReceive() {
    return this.receiveBuilder().build();
  }
}

void main() {
  test("matchAny", () {
    var system = ActorSystem("testSystem");
    system.actorOf(TestAny());
    system.broadcast(Action("hello"));
  });
}
