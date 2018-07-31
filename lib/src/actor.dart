import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/src/actor-ref.dart';
import 'package:dart_actor/src/actor-receive-builder.dart';

abstract class AbstractActor {
  ActorContext context;

  ActorReceive createReceive();

  ActorRef getSelf() {
    return this.context.self;
  }

  ActorRef getSender() {
    return this.context.sender;
  }

  ActorReceiveBuilder receiveBuilder () {
    return new ActorReceiveBuilder();
  }

  void receive() {
    var listeners = createReceive().listeners;
    context.scheduler.replaceLiteners(listeners);
    context.scheduler.start();
    preStart();
  }

  void preStart();

  void postStop();

  void postError(err) {
    throw err;
  }
}
