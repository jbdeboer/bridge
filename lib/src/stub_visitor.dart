import 'package:analyzer_experimental/src/generated/ast.dart' as dart;
import 'jsast/js.dart' as jss;
import 'base_visitor.dart';

class StubVisitor extends BaseVisitor {
  List<jss.Node> visitBlock(dart.Block block) {
    return [new jss.Block(
        [new jss.Comment('// STUB BLOCK')]
    )];
  }

  List<jss.Node> visitStringInterpolation(dart.StringInterpolation node) =>
    [new jss.LiteralString('STUB STRING INTERPOLATION')];
}
