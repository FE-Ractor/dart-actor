import 'package:dart_actor/src/abstract_actor.dart';
import 'package:dart_actor/src/listener.dart';
import 'package:dart_actor/src/actor_system.dart';
import 'package:dart_actor/src/actor_scheduler.dart';
import 'package:dart_actor/src/actor_context.dart';

class ActorRef<T extends AbstractActor> {
  covariant AbstractActor _actor;
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

  T getInstance() {
    return this._actor;
  }

  ActorContext getContext() {
    return this._actor.context;
  }

  tell(dynamic message, [ActorRef sender]) {
    this._actor.context.sender = sender ?? null;
    this._actor.context.scheduler.callback(message);
  }

  Future<R> ask<R>(dynamic message, [ActorRef sender]) {
    this._actor.context.sender = sender ?? null;
    final response = this._actor.context.scheduler.callback(message);

    if (response is Future) {
      if (response is Future<R>) {
        return response;
      }
      throw "${_actor.runtimeType}.answer<${message.runtimeType}> returns ${response.runtimeType} while ask expects $R";
    } else {
      throw "Please use .answer to catch ${message.runtimeType}";
    }
  }
}
