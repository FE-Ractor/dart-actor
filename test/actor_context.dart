//import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/dart_actor.dart';
import "package:test/test.dart";

class Action {
  String message;
  Action(this.message);
}

class Test extends AbstractActor {
  createReceive() {
    return this.receiveBuilder().build();
  }
}

void main() {
  test("get", () {
    var system = ActorSystem("testSystem");
    system.actorOf(Test()).getInstance();
    Test instance = system.getRoot().getContext().get(Test).getInstance();
    expect(instance is Test, true);
  });
}
