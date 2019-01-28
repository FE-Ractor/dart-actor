import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/src/actor_context.dart';
import 'package:dart_actor/src/actor_receive.dart';
import 'package:dart_actor/src/actor_ref.dart';
import 'package:dart_actor/src/actor_receive_builder.dart';

abstract class AbstractActor {
  ActorContext context;

  ActorReceive createReceive();

  ActorRef getSelf() {
    return this.context.self;
  }

  ActorRef getSender() {
    return this.context.sender;
  }

  ActorReceiveBuilder receiveBuilder() {
    return new ActorReceiveBuilder();
  }

  void receive() {
    var listeners = createReceive().listeners;
    context.scheduler.replaceLiteners(listeners);
    context.scheduler.start();
    preStart();
  }

  void preStart() {}

  void postStop() {}

  void postError(err) {
    throw err;
  }
}
