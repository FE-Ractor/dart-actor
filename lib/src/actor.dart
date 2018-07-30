import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/src/actor-ref.dart';
import 'package:dart_actor/src/actor-receive-builder.dart';

abstract class AbstractActor {
  ActorContext context;

  ActorReceive createReceive();

  ActorRef getSelf() {
    return this.context.sender;
  }

  ActorRef getSender() {
    return this.context.sender;
  }

  ActorReceiveBuilder receiveBuilder () {
    return new ActorReceiveBuilder();
  }

  void receive() {
    var listeners = this.createReceive().listeners;
    this.context.scheduler.replaceLiteners(listeners);
  }

  void preStart();

  void postStop();

  void postError(err) {
    throw err;
  }
}
