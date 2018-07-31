import 'package:event_bus/event_bus.dart';
import 'package:uuid/uuid.dart';

import 'package:dart_actor/src/base-event.dart';
import 'package:dart_actor/src/actor.dart';
import 'package:dart_actor/src/actor-ref.dart';
import 'package:dart_actor/src/root-actor.dart';

class ActorSystem {
  EventBus eventStream;
  final String name;
  ActorRef _rootActorRef;
  static final Map<String, ActorSystem> _cache = <String, ActorSystem>{};

  factory ActorSystem(String name) {
    if (_cache.containsKey(name)){
      return _cache[name];
    } else {
      final actorSystem = new ActorSystem._instance(name);
      _cache[name] = actorSystem;
      return actorSystem;
    }
  }

  ActorSystem._instance(this.name) {
    eventStream = new EventBus();
    _rootActorRef = new ActorRef(new RootActor(), this, new List(), null, "root", "root");
  }

  ActorSystem create(String name) {
    return new ActorSystem(name);
  }

  void tell(BaseEvent event) {
    print(event);
    eventStream.fire(event);
  }

  void broadcast(BaseEvent event) {
    eventStream.fire(event);
  }

  ActorRef actorOf(AbstractActor actor, [String name]) {
    var _name = name ?? new Uuid().v4();
    return _rootActorRef.getActor().context.actorOf(actor, _name);
  }

  void stop(ActorRef actorRef) {
    _rootActorRef.getActor().context.stop(actorRef);
  }

  void terminal() {
    eventStream != null ? eventStream.destroy() : null;
    _rootActorRef.getActor().context.children.clear();
  }

  ActorRef getRoot() {
    return _rootActorRef;
  }
}
