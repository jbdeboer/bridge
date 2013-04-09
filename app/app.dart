import '../lib/src/utils.dart';
import '../lib/src/parse.dart';
import '../lib/src/bridge_visitor.dart';

var dartText = "class C { String x; C(this.x); }";

main () {
  print("Hello");

  print("!${
    stringBridge(dartText, (x) => new BridgeVisitor.root())}"
  );
}