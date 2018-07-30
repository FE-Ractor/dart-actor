import 'package:uuid/uuid.dart';

import 'package:dart_actor/src/actor-system.dart';
import 'package:dart_actor/src/actor-scheduler.dart';
import 'package:dart_actor/src/actor.dart';
import 'package:dart_actor/src/actor-ref.dart';
import 'package:dart_actor/src/actor-receive.dart';

class ActorContext {
  Map<String, ActorRef> children = new Map();
  String name;
  ActorRef self;
  ActorSystem system;
  dynamic sender;
  ActorScheduler scheduler;
  ActorRef parent;
  String path;

  ActorContext(this.name, this.self, this.system, this.sender, this.scheduler,
      this.parent, this.path) {}

  ActorRef sctorOf(AbstractActor actor, String name) {
    var _name = name ?? new Uuid().v4();

    var actorRef = new ActorRef(
        actor, system, new List(), self, path + '/' + _name, _name);
    this.children[_name] = actorRef;
    return actorRef;
  }

  dynamic child(String name) {
    var child = this.children[name];

    if (child == null) {
      for(var _child in this.children.values) {
        var targetActor = _child.getActor().context.child(name);
        if (targetActor) return targetActor;
      }
    }
    return child ?? null;
  }

  void stop([ActorRef actorRef]) {
    var _actorRef = actorRef ?? self;

    var context = _actorRef.getActor().context;

    if (self.getActor().context.path == context.path) {
      parent.getActor().context.stop(_actorRef);
    } else {
      var child = children[context.name];
      var _scheduler = child.getActor().context.scheduler;
      _scheduler.cancel();

      child.getActor().postStop();

      for(var _child in child.getActor().context.children.values) {
        _child.getActor().context.stop();
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

  bool isAlive() {
    return scheduler != null ? !scheduler.isCancelled() : false;
  }
}
