import 'package:analyzer_experimental/src/generated/ast.dart';

import '../symbols.dart';
import '../unparse_to_closure/expression_visitor.dart';
import '../utils.dart';


class BlockVisitor extends GeneralizingASTVisitor {
  IndentedStringBuffer _buffer;
  Scope _currentScope;
  ExpressionVisitor expressionVisitor;

  // Visiting sub-blocks constructs a new BlockVisitor.
  bool firstTime = true;

  BlockVisitor({Scope currentScope,
                IndentedStringBuffer buffer}) {
    _currentScope = currentScope.clone();
    _buffer = buffer;
    expressionVisitor = new ExpressionVisitor(
        currentScope: currentScope,
        buffer: buffer);
  }

  Object visitFieldDeclaration(FieldDeclaration node) {
  }

  Object visitVariableDeclaration(VariableDeclaration node) {
    String name = node.name.name;
    var symbolName = new SymbolName(name);
    // Add correct type.  This will assert() if this is a duplicate defn.
    _currentScope.add(symbolName, DartType.DYNAMIC);
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
