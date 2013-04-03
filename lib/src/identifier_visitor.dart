/**
Dart is lexically scoped.  Our Javascript output is not.

nested functions:
function A() {
  var a;
  function B() {
    var b;
   };
   b();
}

no problems, no renaming needed.

classes:
class A() {
  var a;
  B() { a = 3; }
 }

 A.prototype.B = function() {
   this.a = 3;
 }
 */

import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'transformers.dart';
import 'base_visitor.dart';
import 'jsast/js.dart' as js;

class IdentifierVisitor extends BaseVisitor {
  ASTVisitor<Object> otherVisitor;

  IdentifierVisitor(this.otherVisitor);

  visitSimpleIdentifier(SimpleIdentifier node) =>
      [new js.LiteralString(node.name)];
}