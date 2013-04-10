library stub_visitor;

import './analyzer_experimental/ast.dart' as dart;

import 'jsast/js.dart' as jss;

import 'base_visitor.dart';
import 'visit_result.dart';
import 'lexical_scope.dart';

class StubVisitor extends BaseVisitor {
  var printScope;
  get scopeOut => printScope ? " scope:$scope" : "";

  StubVisitor(scope, [printScope = false]) : this.printScope = printScope, super(
      new BaseVisitorOptions((callee) => new StubVisitor(), scope));

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
  visitBlockFunctionBody(node) =>
    VisitResult.fromJsNode(new jss.Block([new jss.Comment('// STUB FUNCTION BODY${scopeOut}')]));

  visitStringInterpolation(dart.StringInterpolation node) =>
      VisitResult.fromJsNode(new jss.LiteralString('STUB STRING INTERPOLATION'));

  visitExpression(node, [printValue = false]) =>
      VisitResult.fromJsNode(new jss.LiteralString('${printValue ? '${node.value}-' : ''}stubEXPR'));
  visitBooleanLiteral(node) => visitExpression(node, true);
  visitIntegerLiteral(node) => visitExpression(node, true);

  visitFunctionExpression(node) => VisitResult.fromJsNode(new jss.Fun([],new jss.Block([new jss.Comment('// STUB FUN')]) ));

  visitIdentifier(node) {
    var type = "IDENTIFIER";
    if (scope != null && scope.currentScope == LexicalScope.METHOD) { type = "METHODID"; }
    return VisitResult.fromJsNode(new jss.LiteralString('stub${type}_${node.name}${scopeOut}'));
  }

  visitSimpleIdentifier(node) => visitIdentifier(node);
  visitPrefixedIdentifier(node) => visitIdentifier(node);
  visitLibraryIdentifier(node) => visitIdentifier(node);

  visitReturnStatement(node) =>
      VisitResult.fromJsNode(new jss.Comment('// STUB'), new jss.Return(null));
}
