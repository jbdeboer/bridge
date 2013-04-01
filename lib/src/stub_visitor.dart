import 'package:analyzer_experimental/src/generated/ast.dart' as dart;
import 'jsast/js.dart' as jss;

class StubVisitor implements dart.ASTVisitor<List<jss.Node>> {
  List<jss.Node> visitBlock(dart.Block block) {
    return [new jss.Comment('// STUB BLOCK')];
  }
}
