import 'package:analyzer_experimental/src/generated/ast.dart' as dart;
import 'jsast/js.dart' as jss;
import 'base_visitor.dart';

class StubVisitor extends BaseVisitor {
  StubVisitor() : super(
      new BaseVisitorOptions((callee) => new StubVisitor(callee), null));

  visitEmptyStatement(node) {
    return [new jss.EmptyStatement()];
  }
  visitBreakStatement(node) {
    return [new jss.Break(null)];
  }
  visitContinueStatement(node) {
    return [new jss.Continue(null)];
  }
  visitBlock(dart.Block block) {
    return [new jss.Block(
        [new jss.Comment('// STUB BLOCK')]
    )];
  }

  visitStringInterpolation(dart.StringInterpolation node) =>
      [new jss.LiteralString('STUB STRING INTERPOLATION')];

  visitBooleanLiteral(node) =>
      [new jss.LiteralBool(node.value)];
  visitIntegerLiteral(node) =>
      [new jss.LiteralNumber('${node.value} /* stubINT */')];
  visitSimpleIdentifier(node) =>
      [new jss.LiteralString('stubIDENTIFIER_${node.name}')];
  visitPrefixedIdentifier(node) =>
      [new jss.LiteralString('stubIDENTIFIER_${node.name}')];
  visitLibraryIdentifier(node) =>
      [new jss.LiteralString('stubIDENTIFIER_${node.name}')];
  visitReturnStatement(node) =>
      [new jss.Comment('// STUB'), new jss.Return(null)];
}
