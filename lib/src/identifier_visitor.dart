library identifier_visitor;

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

import './analyzer_experimental/ast.dart';
import './analyzer_experimental/element.dart' as element;
import './analyzer_experimental/java_core.dart';

import 'jsast/js.dart' as js;

import 'base_visitor.dart';
import 'lexical_scope.dart';
import 'transformers.dart';
import 'visit_result.dart';
import 'type_factory.dart';
import 'identifier_translations.dart';

class IdentifierVisitor extends BaseVisitor {
  // TODO(chirayu):  Use DI to get these so tests can stub them out.
  static final IDENTIFIER_TRANSLATORS = <NameTranslator>[
    new ArrayTranslator(),
    new GlobalNameTranslator(),
  ];

  IdentifierVisitor(baseOptions) :
      super(baseOptions) {
  }

  String translateName(String name, bool isPrefixed) {
    var context = new TranslationContext.fromScope(isPrefixed, scope);
    for (var i = 0; i < IDENTIFIER_TRANSLATORS.length; i++) {
      var translator = IDENTIFIER_TRANSLATORS[i];
      var newName = translator.translateName(name, context);
      if (newName != null) {
        return newName;
      }
    }
    return name;
  }

  visitSimpleIdentifier(SimpleIdentifier node) { return VisitResult.fromJsNode(
      new js.LiteralString(translateName(scope.nameFor(node.name), false))); }

  visitPrefixedIdentifier(PrefixedIdentifier node) { return VisitResult.fromJsNode(
      new js.LiteralString("${scope.nameFor(node.prefix.name)}.${translateName(node.identifier.name, true)}")); }
}
