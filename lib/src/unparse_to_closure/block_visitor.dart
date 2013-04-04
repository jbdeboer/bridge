import 'dart:json';

import 'package:analyzer_experimental/src/generated/ast.dart';
import '../jsast/js.dart' as js;

import '../base_visitor.dart';
import '../lexical_scope.dart';
import '../symbols.dart';
import '../unparse_to_closure/expression_visitor.dart';
import '../utils.dart';
import '../visit_result.dart';

const jsbuilder = js.js;

List<js.Statement> flattenOneLevel(List<List<js.Statement>> statementLists) {
  return statementLists.map((stmtList) => stmtList[0]).toList();
}

class BlockVisitor extends BaseVisitor {
  LexicalScope _currentScope;
  ExpressionVisitor expressionVisitor;

  // Visiting sub-blocks constructs a new BlockVisitor.
  bool firstTime = true;

  BlockVisitor.root(baseOptions): this(
      new LexicalScope(), baseOptions);

  BlockVisitor(LexicalScope currentScope,
               baseOptions) : super(baseOptions) {
    _currentScope = new LexicalScope.clone(currentScope);
    _currentScope.currentScope = LexicalScope.UNQUALIFIED;
  }

  js.ExpressionStatement getNewVarJsNode(String name) {
    return new js.ExpressionStatement(new js.VariableDeclaration(name));
  }

  VisitResult visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    List<js.Statement> statements = [];
    for (var variable in node.variables.variables) {
      Expression initializer = variable.initializer;
      String name = variable.name.name;
      _currentScope.addName(name);
      js.Node expression = null;
      if (initializer != null) {
        expression = initializer.accept(otherVisitor).node;
      }
      var statement = new js.ExpressionStatement(
          jsbuilder.defineVar(name, expression));
      statements.add(statement);
    }
    return VisitResult.fromJsNodeList(statements);
  }

  List<js.Statement> getStatements(Block block) {
    return flattenOneLevel(
        block.statements.elements.map(
            (stmt) => stmt.accept(this).nodes).toList());
  }

  VisitResult visitEmptyStatement(EmptyStatement node) {
    return VisitResult.fromJsNode(new js.EmptyStatement());
  }

  // TODO(chirayu): We need a flag on our options object to indicate if asserts
  // should be compiled away to nop or stay.
  VisitResult visitAssertStatement(AssertStatement node) {
    js.Node condition = node.condition.accept(otherVisitor).node;
    var throwStatement = new js.Throw(new js.LiteralString(stringify(
        "Assertion failed for dart expression: ${node.toString()}")));
    return VisitResult.fromJsNode(jsbuilder.if_(condition, [throwStatement]));
  }

  VisitResult visitBreakStatement(BreakStatement _break) {
    if (_break.label != null) {
      throw "Break statements with labels are not supported yet.";
    }
    return VisitResult.fromJsNode(new js.Break(null));
  }

  VisitResult visitContinueStatement(ContinueStatement _continue) {
    if (_continue.label != null) {
      throw "Continue statements with labels are not supported yet.";
    }
    return VisitResult.fromJsNode(new js.Continue(null));
  }

  VisitResult visitReturnStatement(ReturnStatement _return) {
    var expr = null;
    if (_return.expression != null) {
      expr = _return.expression.accept(this.otherVisitor).node;
    }
    return VisitResult.fromJsNode(new js.Return(expr));
  }

  VisitResult visitIfStatement(IfStatement _if) {
    js.Node condition = _if.condition.accept(otherVisitor).node;
    List<js.Statement> thenStatements = _if.thenStatement.accept(this).nodes;
    List<js.Statement> elseStatements = null;
    if (_if.elseStatement != null) {
      elseStatements = _if.elseStatement.accept(this).nodes;
    }
    return VisitResult.fromJsNode(jsbuilder.if_(condition, thenStatements, elseStatements));
  }

  VisitResult visitWhileStatement(WhileStatement _while) {
    js.Node condition = _while.condition.accept(this.otherVisitor).node;
    List<js.Statement> body = _while.body.accept(this).nodes;
    return VisitResult.fromJsNode(jsbuilder.while_(condition, body));
  }

  VisitResult visitBlock(Block block) {
    if (!firstTime) {
      var v = new BlockVisitor(_currentScope,
                               this.otherVisitor);
      return v.visitBlock(block);
    } else {
      return VisitResult.fromJsNode(new js.Block(getStatements(block)));
    }
  }
}
