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
import 'package:analyzer_experimental/src/generated/element.dart' as element;
import 'package:analyzer_experimental/src/generated/java_core.dart';

import 'jsast/js.dart' as js;

import 'base_visitor.dart';
import 'lexical_scope.dart';
import 'transformers.dart';
import 'visit_result.dart';

import 'type_factory.dart';


final element.Type2 ARRAY_TYPE = typeFactory('List', []);

class IdentifierVisitor extends BaseVisitor {
  //LexicalScope scope;
  maybeSqrt(String s, [forceMethod = false]) {
    if (scope != null) {
      if (forceMethod || scope.currentScope == LexicalScope.METHOD) {
        if (scope.currentType != null && scope.currentType.isSubtypeOf(ARRAY_TYPE)) {
          return s == 'add' ? 'push' : s;
        }
        return s;
      }
          }
    // not for method
    return s == 'sqrt' ? 'Math.sqrt' : s;
  }
  IdentifierVisitor(baseOptions) :
      super(baseOptions) {
  }

  visitSimpleIdentifier(SimpleIdentifier node) { print('sim'); return VisitResult.fromJsNode(
      new js.LiteralString(maybeSqrt(scope.nameFor(node.name)))); }

  visitPrefixedIdentifier(PrefixedIdentifier node) { print('pre'); return VisitResult.fromJsNode(
      new js.LiteralString("${scope.nameFor(node.prefix.name)}.${maybeSqrt(node.identifier.name, true)}")); }
}
