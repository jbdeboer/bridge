import './analyzer_experimental/ast.dart';
import './analyzer_experimental/element.dart' as element;
import './analyzer_experimental/java_core.dart';

import 'lexical_scope.dart';
import 'type_factory.dart';

final element.Type2 ARRAY_TYPE = typeFactory('List', []);
final element.Type2 NUMBER_TYPE = typeFactory('num', null);

class TranslationContext {
  bool isPrefixed;
  int currentScope;
  element.Type2 currentType;
  TranslationContext({
      bool isPrefixed, int currentScope, element.Type2 currentType})
      : this.isPrefixed = isPrefixed,
        this.currentScope = currentScope, 
        this.currentType = currentType;

  TranslationContext.fromScope(bool isPrefixed, LexicalScope scope):
      this(isPrefixed: isPrefixed,
           currentScope: scope.currentScope,
           currentType: scope.currentType);
}


abstract class NameTranslator {
  // If you can't handle this case, return null.  Otherwise the translated name.
  String translateName(String name, TranslationContext context);
}

class ArrayTranslator extends NameTranslator {
  static const directRenames = const <String, String> {
    "add": "push",
    "removeRange": "splice",
    "where": "filter",  // ECMAScript 1.6
    // The following aren't renamed but listed here for completeness.
    "forEach": "forEach",  // ECMAScript 1.6
    "indexOf": "indexOf",  // ECMAScript 1.6
    "every": "every",  // ECMAScript 1.6
  };

  // Shortcut to bail out early.
  bool _shouldSkip(TranslationContext context) {
    return ((context.currentScope != LexicalScope.METHOD && !context.isPrefixed) ||
            context.currentType == null ||
            !context.currentType.isSubtypeOf(ARRAY_TYPE));
  } 

  String translateName(String name, TranslationContext context) {
    return _shouldSkip(context) ? null : directRenames[name];
  }
}

/**
 * TODO(chirayu):
 *   Handle (2.4).round() -> Math.round(2.4)
 */
// class NumberTranslator extends NameTranslator {
//   static const directRenames = const <String, String> {
//     "round": "Math.round",
// }

class GlobalNameTranslator extends NameTranslator {
  static const directRenames = const <String, String> {
    "sqrt": "Math.sqrt",
    "PI": "Math.PI",
    "min": "Math.min",
    "max": "Math.max",
  };

  // Shortcut to bail out early.
  bool _shouldSkip(TranslationContext context) {
    return (context.isPrefixed || context.currentScope != LexicalScope.UNQUALIFIED);
  } 

  String translateName(String name, TranslationContext context) {
    return _shouldSkip(context) ? null : directRenames[name];
  }
}
