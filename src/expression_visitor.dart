import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'transformers.dart';

class StringWriter extends StringBuffer {
  print(x) => write(x);
  println(x) => writeln(x);
}
class ExpressionVisitor extends ToSourceVisitor {
   bool inPrefix = false;

   String get js => _buffer.toString();
   StringWriter _buffer;
   ExpressionVisitor(buffer) : super(buffer), _buffer = buffer;
   ExpressionVisitor.def() : this(new StringWriter());

  Object visitSimpleIdentifier(SimpleIdentifier node) {
    if (inPrefix) { return super.visitSimpleIdentifier(node); }
    if (node.name == "other") {
      _buffer.write("other");
    } else {
      _buffer.write("this.${node.name}");
    }
  }

  Object visitPrefixedIdentifier(PrefixedIdentifier node) {
    visit(node.prefix);
    _buffer.print('.');
    inPrefix = true;
    visit(node.identifier);
    inPrefix = false;
    return null;

  }
}
