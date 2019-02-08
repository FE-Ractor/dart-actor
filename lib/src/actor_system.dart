import 'package:dart_actor/dart_actor.dart';
import 'package:dart_actor/src/abstract_actor.dart';
import 'package:dart_actor/src/actor_ref.dart';
import 'package:event_bus/event_bus.dart';
import 'package:uuid/uuid.dart';
import 'package:dart_actor/src/root_actor.dart';

class ActorSystem {
  EventBus eventBus = new EventBus();
  final String name;
  ActorRef _rootActorRef;

  ActorSystem(this.name) {
    _rootActorRef = new ActorRef(
        new RootActor(), this, new List<Listener>(), null, "root", "root");
  }

  ActorSystem create(String name) {
    return new ActorSystem(name);
  }

  ActorRef getRoot() {
    return _rootActorRef;
  }

  // TODO: complete type
  ActorRef<dynamic> get<T extends AbstractActor>() {
    return _rootActorRef.getInstance().context.get<T>();
  }

  void dispatch(dynamic message) {
    broadcast(message);
  }

  void broadcast(dynamic message) {
    eventBus.fire(message);
  }

  ActorRef actorOf(AbstractActor actor, [String name]) {
    var _name = name ?? new Uuid().v4();
    return _rootActorRef.getContext().actorOf(actor, _name);
  }

  void stop(ActorRef actorRef) {
    _rootActorRef.getContext().stop(actorRef);
  }

  void terminal() {
    eventBus.destroy();
    _rootActorRef.getContext().children.clear();
  }
}
