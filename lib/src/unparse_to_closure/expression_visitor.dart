library unparse_expression_visitor;

import './../analyzer_experimental/ast.dart';
import '../symbols.dart';
import '../utils.dart';


// TODO(chirayu):  This needs to grow up and not rely on the incorrect
// ToSourceVisitor.
class ExpressionVisitor extends ToSourceVisitor {
  IndentedStringBuffer _buffer;
  Scope _currentScope;
  bool inPrefix = false;

  ExpressionVisitor({Scope currentScope,
                     IndentedStringBuffer buffer}): super(buffer) {
    _currentScope = currentScope.clone();
    _buffer = buffer;
  }
}
