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

import 'jsast/js.dart' as js;

import 'base_visitor.dart';
import 'lexical_scope.dart';
import 'transformers.dart';
import 'visit_result.dart';

maybeSqrt(s) => s == 'sqrt' ? 'Math.sqrt' : s;

class IdentifierVisitor extends BaseVisitor {
  //LexicalScope scope;

  IdentifierVisitor(baseOptions) :
      super(baseOptions) {
  }

  visitSimpleIdentifier(SimpleIdentifier node) => VisitResult.fromJsNode(
      new js.LiteralString(maybeSqrt(scope.nameFor(node.name))));

  visitPrefixedIdentifier(PrefixedIdentifier node) => VisitResult.fromJsNode(
      new js.LiteralString("${scope.nameFor(node.prefix.name)}.${node.identifier}"));
}
