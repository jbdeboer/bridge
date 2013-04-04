import 'package:analyzer_experimental/src/generated/ast.dart';

import '../base_visitor.dart';
import '../jsast/js.dart' as js;
import '../symbols.dart';
import '../unparse_to_closure/expression_visitor.dart';
import '../utils.dart';
import '../lexical_scope.dart';


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
    // TODO(chirayu): This should use otherVisitor passing it the currentScope.
    // expressionVisitor = new ExpressionVisitor(
    //     currentScope: currentScope,
    //     buffer: buffer);
  }

  js.ExpressionStatement getNewVarJsNode(String name) {
    return new js.ExpressionStatement(new js.VariableDeclaration(name));
  }

  Object visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    List<js.Statement> statements = [];
    for (var variable in node.variables.variables) {
      SimpleIdentifier name = variable.name;
      Expression initializer = variable.initializer;
      js.Node nameStatement = name.accept(otherVisitor)[0];
      js.Node expression = null;
      if (initializer != null) {
        js.Node expression = initializer.accept(otherVisitor)[0];
      }
      var statement = new js.ExpressionStatement(
          new js.VariableDeclarationList([
              new js.VariableInitialization(
                 new js.VariableDeclaration.fromLiteralString(nameStatement),
                 expression
                 )]));
      statements.add(statement);
    }
    return statements;
  }

  List<Statement> getStatements(Block block) {
    return flattenOneLevel(
        block.statements.elements.map(
            (stmt) => stmt.accept(this)).toList());
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
