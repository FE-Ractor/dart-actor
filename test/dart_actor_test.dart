//import 'package:dart_actor/dart_actor.dart';
import "package:test/test.dart";

void main() {
  test("String.trim() removes surrounding whitespace", () {
    var string = "  foo ";
    expect(string.trim(), equals("foo"));
  });
}
