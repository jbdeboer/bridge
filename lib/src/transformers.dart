library transformers;

import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'expression_visitor.dart';

String dartType2jsType(TypeName dartType) {
  if (dartType.name.name == 'String') {
    return 'string';
  }
  throw "Not implemented $dartType";
}

String dartExpression2js(Expression expr) {
  ExpressionVisitor ev = new ExpressionVisitor.def();
  expr.accept(ev);
  return ev.js;
}

String variableDeclarationToString(VariableDeclaration decl,
                                   TypeName nodeType,
                                   String namespace) {
  String typeString = '';
  String declString = '';
  var name = decl.name.toString();
// print the type information first.
  if (nodeType != null) {
    String jsType = dartType2jsType(nodeType);
    typeString = '/\** @type {${jsType}} */\n';
  }
  if (decl.initializer != null) {
    var expression = "33";
    //var expression = dartExpression2js(decl.initializer);
    declString = "$namespace$name = $expression;";
  } else {
    declString = "$namespace$name;";
  }
  return "$typeString$declString";
}
