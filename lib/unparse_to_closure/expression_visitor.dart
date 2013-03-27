import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:dart2closure/utils.dart';


// TODO(chirayu):  This needs to grow up and not rely on the incorrect
// ToSourceVisitor.
class ExpressionVisitor extends ToSourceVisitor {
  IndentedStringBuffer _buffer;
  Scope _instanceScope;
  Scope _currentScope;
  bool inPrefix = false;

  ExpressionVisitor({Scope currentScope,
                     Scope instanceScope,
                     IndentedStringBuffer buffer}): super(buffer) {
    _currentScope = currentScope.clone();
    _instanceScope = instanceScope;
    _buffer = buffer;
  }
}
