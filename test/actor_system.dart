//import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/src/actor_receive_builder.dart';
import "package:test/test.dart";

class Action {
  String message;
  Action(this.message);
}

class TestAny extends AbstractActor {
  createReceive() {
    return this.receiveBuilder().build();
  }
}

void main() {
  test("matchAny", () {
    var system = ActorSystem("testSystem");
    var store = TestAny();
    system.actorOf(store);
    var receive = ActorReceiveBuilder.create().matchAny((action) {
      expect(action.message, "hello");
    }).build();
    store.context.become(receive);
    system.broadcast(Action("hello"));
  });

  test("get", () {
    var system = ActorSystem("testSystem");
    system.actorOf(TestAny());
    var instance = system.get(TestAny).getInstance();
    expect(instance is TestAny, true);
  });
}
