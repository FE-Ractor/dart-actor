import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/src/actor_receive.dart';
import 'package:dart_actor/src/actor_scheduler.dart';
import 'package:uuid/uuid.dart';

import 'package:dart_actor/src/actor_system.dart';
import 'package:dart_actor/src/abstract_actor.dart';
import 'package:dart_actor/src/actor_ref.dart';

class ActorContext {
  Map<String, ActorRef> children = new Map();
  String name;
  ActorRef self;
  ActorSystem system;
  ActorRef sender;
  ActorScheduler scheduler;
  ActorRef parent;
  String path;

  ActorContext(this.name, this.self, this.system, this.sender, this.scheduler,
      this.parent, this.path) {}

  ActorRef actorOf(AbstractActor actor, String name) {
    var _name = name ?? new Uuid().v4();

    var actorRef = new ActorRef(
        actor, system, new List<Listener>(), self, path + '/' + _name, _name);
    this.children[_name] = actorRef;
    actor.receive();
    return actorRef;
  }

  ActorRef child(String name) {
    var child = this.children[name];

    if (child == null) {
      for (var _child in this.children.values) {
        var targetActor = _child.getContext().child(name);
        if (targetActor != null) return targetActor;
      }
    }
    return child ?? null;
  }

  // TODO: complete type annotation
  ActorRef<dynamic> get<T extends AbstractActor>() {
    var queue = this.children.values.toList();
    while (!queue.isEmpty) {
      var ref = queue.removeAt(0);
      var instance = ref.getInstance();
      if (instance.context.children.length > 0) {
        queue.addAll(instance.context.children.values);
      }
      if (instance is T) {
        return ref;
      }
    }
    return null;
  }

  void stop([ActorRef actorRef]) {
    var _actorRef = actorRef ?? self;

    var context = _actorRef.getContext();

    if (self.getContext().path == context.path) {
      parent.getContext().stop(_actorRef);
    } else {
      var child = children[context.name];
      var _scheduler = child.getContext().scheduler;
      _scheduler.cancel();

      child.getInstance().postStop();

      for (var _child in child.getContext().children.values) {
        _child.getContext().stop();
      }

      this.children.remove(context.name);
    }
  }

  become(ActorReceive behavior) {
    scheduler.cancel();
    var listeners = behavior.listeners;
    scheduler.replaceLiteners(listeners);
    scheduler.start();
  }
}
