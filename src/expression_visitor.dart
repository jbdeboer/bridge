import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'transformers.dart';
import '../lib/utils.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';



class ExpressionVisitor extends ToSourceVisitor {
   bool inPrefix = false;

   String get js => _buffer.toString();
   StringWriter _buffer;
   ExpressionVisitor(buffer) : super(buffer), _buffer = buffer;
   ExpressionVisitor.def() : this(new StringWriter());

  Object visitSimpleIdentifier(SimpleIdentifier node) {
    if (inPrefix) { return super.visitSimpleIdentifier(node); }
    if (node.name == "other") {
      _buffer.print("other");
    } else {
      _buffer.print("this.${node.name}");
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
