import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/src/actor_receive_builder.dart';
import "package:test/test.dart";

class Action {
  String message;
  Action(this.message);
}

class TestStore extends AbstractActor {
  createReceive() {
    return this.receiveBuilder().build();
  }
}

void main() {
  test("match", () {
    final system = ActorSystem("testSystem");
    final testStore = TestStore();
    system.actorOf(testStore);
    final testBuilder = ActorReceiveBuilder().match<Action>((action) {
      expect(action.message, "hello");
    }).build();
    testStore.context.become(testBuilder);
    system.broadcast(Action("hello"));
  });

  test("matchAny", () {
    final system = ActorSystem("testSystem");
    final testStore = TestStore();
    system.actorOf(testStore);
    final testBuilder = ActorReceiveBuilder().matchAny((action) {
      expect(action.message, "hello");
    }).build();
    testStore.context.become(testBuilder);
    system.broadcast(Action("hello"));
  });

  test("ask and answer", () async {
    final system = ActorSystem("testSystem");
    final testStore = TestStore();
    final testStoreRef = system.actorOf(testStore);
    final testBuilder = ActorReceiveBuilder().answer<Action>((message) async {
      return "has receive hello.";
    }).build();
    testStore.context.become(testBuilder);

    final response = await testStoreRef.ask<String>(Action("hello"));

    expect(response, "has receive hello.");
  });
}
