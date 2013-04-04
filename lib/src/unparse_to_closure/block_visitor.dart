import 'package:analyzer_experimental/src/generated/ast.dart';

import '../base_visitor.dart';
import '../jsast/js.dart' as js;
import '../symbols.dart';
import '../unparse_to_closure/expression_visitor.dart';
import '../utils.dart';
import '../lexical_scope.dart';

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
  }

  js.ExpressionStatement getNewVarJsNode(String name) {
    return new js.ExpressionStatement(new js.VariableDeclaration(name));
  }

  Object visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    List<js.Statement> statements = [];
    for (var variable in node.variables.variables) {
      Expression initializer = variable.initializer;
      String name = variable.name.name;
      _currentScope.addName(name);
      js.Node expression = null;
      if (initializer != null) {
        expression = initializer.accept(otherVisitor)[0];
      }
      var statement = new js.ExpressionStatement(
          jsbuilder.defineVar(name, expression));
      statements.add(statement);
    }
    return statements;
  }

  List<js.Statement> getStatements(Block block) {
    return flattenOneLevel(
        block.statements.elements.map(
            (stmt) => stmt.accept(this)).toList());
  }

  List<js.Statement> visitEmptyStatement(EmptyStatement node) {
    return [new js.EmptyStatement()];
  }

  List<js.Statement> visitBreakStatement(BreakStatement _break) {
    if (_break.label != null) {
      throw "Break statements with labels are not supported yet.";
    }
    return [new js.Break(null)];
  }

  List<js.Statement> visitContinueStatement(ContinueStatement _continue) {
    if (_continue.label != null) {
      throw "Continue statements with labels are not supported yet.";
    }
    return [new js.Continue(null)];
  }

  List<js.Statement> visitReturnStatement(ReturnStatement _return) {
    return [new js.Return(null)];
  }

  List<js.Statement> visitIfStatement(IfStatement _if) {
    js.Node condition = _if.condition.accept(otherVisitor)[0];
    List<js.Statement> thenStatements = _if.thenStatement.accept(this);
    List<js.Statement> elseStatements = null;
    if (_if.elseStatement != null) {
      elseStatements = _if.elseStatement.accept(this);
    }
    return [jsbuilder.if_(condition, thenStatements, elseStatements)];
  }

  Object visitBlock(Block block) {
    if (!firstTime) {
      var v = new BlockVisitor(_currentScope,
                               this.otherVisitor);
      return v.visitBlock(block);
    } else {
      return [new js.Block(getStatements(block))];
    }
  }
}
