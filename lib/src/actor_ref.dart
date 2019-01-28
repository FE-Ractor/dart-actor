import 'package:dart_actor/src/abstract_actor.dart';
import 'package:dart_actor/src/listener.dart';
import 'package:dart_actor/src/actor_system.dart';
import 'package:dart_actor/src/actor_scheduler.dart';
import 'package:dart_actor/src/actor_context.dart';

class ActorRef {
  AbstractActor _actor;
  ActorSystem system;
  List<Listener> listeners;
  ActorRef parent;
  String path;
  String name;

  ActorRef(this._actor, this.system, listeners, parent, path, name) {
    var scheduler =
        new ActorScheduler(system.eventBus, path, listeners, _actor);
    var context =
        new ActorContext(name, this, system, null, scheduler, parent, path);

    _actor.context = context;
  }

  AbstractActor getInstance() {
    return this._actor;
  }

  ActorContext getContext() {
    return this._actor.context;
  }

  tell(dynamic message, [ActorRef sender]) {
    this._actor.context.sender = sender ?? null;
    this._actor.context.scheduler.callback(message);
  }
}
