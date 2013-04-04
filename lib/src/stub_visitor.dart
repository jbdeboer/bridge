import 'package:analyzer_experimental/src/generated/ast.dart' as dart;

import 'jsast/js.dart' as jss;

import 'base_visitor.dart';
import 'visit_result.dart';

class StubVisitor extends BaseVisitor {
  StubVisitor() : super(
      new BaseVisitorOptions((callee) => new StubVisitor(callee), null));

  visitEmptyStatement(node) {
    return VisitResult.fromJsNode(new jss.EmptyStatement());
  }
  visitBreakStatement(node) {
    return VisitResult.fromJsNode(new jss.Break(null));
  }
  visitContinueStatement(node) {
    return VisitResult.fromJsNode(new jss.Continue(null));
  }
  visitBlock(dart.Block block) {
    return VisitResult.fromJsNode(
        new jss.Block([new jss.Comment('// STUB BLOCK')]
    ));
  }

  visitStringInterpolation(dart.StringInterpolation node) =>
      VisitResult.fromJsNode(new jss.LiteralString('STUB STRING INTERPOLATION'));

  visitBooleanLiteral(node) =>
      VisitResult.fromJsNode(new jss.LiteralBool(node.value));
  visitIntegerLiteral(node) =>
      VisitResult.fromJsNode(new jss.LiteralNumber('${node.value} /* stubINT */'));
  visitSimpleIdentifier(node) =>
      VisitResult.fromJsNode(new jss.LiteralString('stubIDENTIFIER_${node.name}'));
  visitPrefixedIdentifier(node) =>
      VisitResult.fromJsNode(new jss.LiteralString('stubIDENTIFIER_${node.name}'));
  visitLibraryIdentifier(node) =>
      VisitResult.fromJsNode(new jss.LiteralString('stubIDENTIFIER_${node.name}'));
  visitReturnStatement(node) =>
      VisitResult.fromJsNode(new jss.Comment('// STUB'), new jss.Return(null));
}
