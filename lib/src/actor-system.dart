import 'package:dart_event_emitter/dart_event_emitter.dart';
import 'package:uuid/uuid.dart';

import 'package:dart_actor/src/base-event.dart';
import 'package:dart_actor/src/actor.dart';
import 'package:dart_actor/src/actor-ref.dart';
import 'package:dart_actor/src/root-actor.dart';

class ActorSystem {
  EventEmitter eventStream;
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
    eventStream = new EventEmitter();
    _rootActorRef = new ActorRef(new RootActor(), this, new List(), null, "root", "root");
  }

  ActorSystem create(String name) {
    return new ActorSystem(name);
  }

  void tell(String event, Object message) {
    print(event);
    eventStream.emit(event, message);
  }

  void broadcast(String event, Object message) {
    eventStream.emit(event, message);
  }

  ActorRef actorOf(AbstractActor actor, [String name]) {
    var _name = name ?? new Uuid().v4();
    return _rootActorRef.getActor().context.actorOf(actor, _name);
  }

  void stop(ActorRef actorRef) {
    _rootActorRef.getActor().context.stop(actorRef);
  }

  void terminal() {
    eventStream != null ? eventStream.removeAllListeners() : null;
    _rootActorRef.getActor().context.children.clear();
  }

  ActorRef getRoot() {
    return _rootActorRef;
  }
}
