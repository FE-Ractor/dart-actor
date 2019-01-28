class Listener {
  dynamic message;
  dynamic Function(dynamic entity) callback;

  Listener(this.callback, [this.message = null]);
}
