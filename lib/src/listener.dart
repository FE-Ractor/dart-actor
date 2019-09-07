enum ListenerType { match, answer }

class Listener {
  ListenerType type;
  dynamic message;
  dynamic Function(dynamic entity) callback;

  Listener(this.type, this.callback, [this.message = null]);
}
