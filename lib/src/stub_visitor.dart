library stub_visitor;

import './analyzer_experimental/ast.dart' as dart;

import 'jsast/js.dart' as jss;

import 'base_visitor.dart';
import 'visit_result.dart';
import 'lexical_scope.dart';

class StubVisitor extends BaseVisitor {
  StubVisitor() : super(
      new BaseVisitorOptions((callee) => new StubVisitor(), null));

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

  visitIdentifier(node) {
    var type = "IDENTIFIER";
    if (scope != null && scope.currentScope == LexicalScope.METHOD) { type = "METHODID"; }
    return VisitResult.fromJsNode(new jss.LiteralString('stub${type}_${node.name}'));
  }

  visitSimpleIdentifier(node) => visitIdentifier(node);
  visitPrefixedIdentifier(node) => visitIdentifier(node);
  visitLibraryIdentifier(node) => visitIdentifier(node);

  visitReturnStatement(node) =>
      VisitResult.fromJsNode(new jss.Comment('// STUB'), new jss.Return(null));
}
