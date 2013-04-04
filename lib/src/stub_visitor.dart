import 'package:analyzer_experimental/src/generated/ast.dart' as dart;
import 'jsast/js.dart' as jss;
import 'base_visitor.dart';

class StubVisitor extends BaseVisitor {
  StubVisitor() : super(new BaseVisitorOptions((callee) => new StubVisitor(callee), null)) {
    print("new stub");
  }

  visitBlock(dart.Block block) {
    return [new jss.Block(
        [new jss.Comment('// STUB BLOCK')]
    )];
  }

  visitStringInterpolation(dart.StringInterpolation node) =>
      [new jss.LiteralString('STUB STRING INTERPOLATION')];

  visitSimpleIdentifier(node) =>
      [new jss.LiteralString('stubIDENTIFIER_${node.name}')];
  visitPrefixedIdentifier(node) =>
      [new jss.LiteralString('stubIDENTIFIER_${node.name}')];
  visitLibraryIdentifier(node) =>
      [new jss.LiteralString('stubIDENTIFIER_${node.name}')];
}
