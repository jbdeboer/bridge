import 'package:analyzer_experimental/src/generated/ast.dart';

import 'package:dart2closure/symbols.dart';
import 'package:dart2closure/unparse_to_closure/expression_visitor.dart';
import 'package:dart2closure/utils.dart';


class BlockVisitor extends GeneralizingASTVisitor {
  IndentedStringBuffer _buffer;
  Scope _instanceScope;
  Scope _currentScope;
  ExpressionVisitor expressionVisitor;

  bool firstTime = true;

  BlockVisitor({Scope currentScope,
                Scope instanceScope,
                IndentedStringBuffer buffer}) {
    _currentScope = currentScope.clone();
    _instanceScope = instanceScope;
    _buffer = buffer;
    expressionVisitor = new ExpressionVisitor(
        currentScope: currentScope,
        instanceScope: instanceScope,
        buffer: buffer);
  }

  Object visitFieldDeclaration(FieldDeclaration node) {
  }

  Object visitVariableDeclaration(VariableDeclaration node) {
    var name = node.name;
    var symbolName = new SymbolName(name);
    // Add correct type.  This will assert() if this is a duplicate defn.
    _currentScope.add(SymbolName, DartType.DYNAMIC);
    if (node.initializer == null) {
      _buffer.writeln("var $name;");
    } else {
      _buffer.write("var $name = ");
      node.initializer.accept(expressionVisitor);
      _buffer.writeln(";");
    }
  }

  Object visitBlockFunctionBody(BlockFunctionBody node) {
    visitBlock(node.block);
  }

  Object visitBlock(Block block) {
    if (!firstTime) {
      var v = new BlockVisitor(currentScope: _currentScope,
                               instanceScope: _instanceScope,
                               buffer: _buffer);
      return v.visitBlock(block);
    } else {
      _buffer.writeln("{");
      _buffer.level++;
      for (final Statement stmt in block.statements) {
        stmt.accept(this);
      }
      _buffer.level--;
      _buffer.writeln("}");
    }
  }
}
