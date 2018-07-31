import 'package:dart_actor/src/actor.dart';
import 'package:dart_actor/src/listener.dart';
import 'package:dart_actor/src/actor-system.dart';
import 'package:dart_actor/src/actor-scheduler.dart';
import 'package:dart_actor/src/actor-context.dart';

class ActorRef {
  AbstractActor _actor;
  ActorSystem system;
  List<Listener> listeners;
  ActorRef parent;
  String path;
  String name;

  ActorRef(this._actor, this.system, this.listeners, this.parent, this.path,
      this.name) {
    var scheduler = new ActorScheduler(system.eventStream, path, listeners, _actor);
    var context = new ActorContext(name, this, system, null, scheduler, parent, path);

    _actor.context = context;
  }

  AbstractActor getActor() {
    return this._actor;
  }

  tell(Object message, [ActorRef sender]) {
    this._actor.context.sender = sender ?? null;
    this._actor.context.scheduler.callback(message);
  }
}
