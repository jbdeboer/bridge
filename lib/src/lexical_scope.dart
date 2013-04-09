library lexical_scope;

//typedef LexicalScopeType int;

import './analyzer_experimental/element.dart' as element;


/**
 * Collections of symbols available in a Dart lexical scope.
 *
 * Nested blocks can just .clone() the current scope and use it as the inner
 * scope.  New declarations can then be put into it.  Throw away when you leave
 * the scope.
 */
class LexicalScope {
  static int UNQUALIFIED = 1;
  static int CLASS = 2;
  static int METHOD = 3;

  var _symbols = new Map<String, int>();
  int currentScope = UNQUALIFIED;
  element.Type2 currentType;
  LexicalScope parent;

  String nameFor(String id) {
    if (_symbols.containsKey(id)) {
      if (_symbols[id] == CLASS) { return "this.$id"; }
      return id;
    }
    if (parent != null) {
      return parent.nameFor(id);
    }
    return id;
  }

  addName(String id) {
    if (_symbols.containsKey(id)) {
      throw "Duplicate definition for name: $id";
    }
    _symbols[id] = currentScope;
  }

  LexicalScope();
  LexicalScope.clone(scope) {
    this.parent = scope;
    this.currentScope = parent.currentScope;
  }
}
