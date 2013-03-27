// TODO(chirayu): Define extensible Dart types.  Basic types will have
// predefined behavior, and more complex types can choose between "Dart source
// specified" behavior or "Bridge overriden definition" behaviors.

class DartType {
  static const DYNAMIC = const DartType._internal("Dynamic");
  static const STRING = const DartType._internal("String");
  static const NUMBER = const DartType._internal("num");
  static const INTEGER = const DartType._internal("int");
  static const DOUBLE = const DartType._internal("double");

  final String name;
  const DartType._internal(this.name);
}


class BaseException implements Exception {
  final String reason;
  BaseException(this.reason);
  String toString() => 'BaseException: $reason';
}


// TODO(chirayu):  Either merge this with Symbol or get rid of it.
class SymbolName {
  final String name;
  static Map<String, SymbolName> _cache = {};

  int get hashCode => name.hashCode;

  SymbolName._internal(this.name);

  factory SymbolName(String name) {
    if (_cache.containsKey(name)) {
      return _cache[name];
    } else {
      final interned = new SymbolName._internal(name);
      _cache[name] = interned;
      return interned;
    }
  }
}


// TODO(chirayu): Associate line number and file info with definitions.
class Symbol {
  final SymbolName name;
  final DartType type;
  Symbol(this.name, [this.type = DartType.DYNAMIC]);
}


/**
 * Collections of symbols available in a Dart lexical scope.
 *
 * Nested blocks can just .clone() the current scope and use it as the inner
 * scope.  New declarations can then be put into it.  Throw away when you leave
 * the scope.
 */
class Scope {
  final Map<SymbolName, Symbol> _symbols;

  Scope() : this._internal({});
  Scope._internal(this._symbols);

  add(SymbolName name, DartType type) {
    if (_symbols.containsKey(name)) {
      // TODO(chirayu): Track line numbers, etc. for better error messages.
      // throw new BaseException("Duplicate definition of symbol '${name}'");
    }
    _symbols[name] = type;
  }

  Symbol operator [](name) {
    if (name is String) name = new SymbolName(name);
    return _symbols[name];
  }

  clone() {
    return new Scope._internal(new Map.from(_symbols));
  }
}


final DEFAULT_GLOBALS = new Scope();
