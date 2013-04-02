import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';


import 'package:unittest/unittest.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';

import '../lib/src/listeners.dart';
import '../lib/src/parse.dart';
import '../lib/src/utils.dart';
import '../lib/src/debug.dart';

import '../lib/src/expression_visitor.dart';
import '../lib/src/stub_visitor.dart';
import '../lib/src/jsast/js.dart' as js;


stringBridge(String dart) {
  PrintStringWriter psw = new PrintStringWriter();
  CompilationUnit n = parseText("var x = $dart");
  Expression expr =
    n.sortedDirectivesAndDeclarations[0].
        variables.variables[0].initializer;

  var visitor = new ExpressionVisitor(new StubVisitor());

  for (var s in expr.accept(visitor)) {
    psw.print(js.prettyPrint(s).getText());
  }
  return psw.toString();
}

class BVT {
  static expectParse(String dart, String jsCode) {
    expect(stringBridge(dart), equals(jsCode));
  }
}

main() {

  // Basic literals.

  test('should parse string literals', () {
    BVT.expectParse('"A"', '"A"');
  });

  test('should parse integers', () {
    BVT.expectParse('4', '4');
  });

  test('should parse doubles', () {
    BVT.expectParse('4.3', '4.3');
  });

  test('should parse booleans', () {
    BVT.expectParse('true', 'true');
  });

  test('should parse null literals', () {
    BVT.expectParse('null', 'null');
  });

  // Typed literals.

  test('should parse list literals', () {
    BVT.expectParse('[]', '[]');
  });

  test('should parse list literals', () {
    BVT.expectParse('[1,2]', '[1, 2]');
  });

  test('should parse map literals', () {
    BVT.expectParse('{}', '{}');
  });

  test('should parse map literals with properties', () {
    BVT.expectParse('{"a":1, "b":2}', '{a: 1, b: 2}');
  });

  // String literals.

  test('should parse adjacent strings', () {
    BVT.expectParse('"a" "b"', '"a" + "b"');
  });

  test('should parse string interpolation', () {
    BVT.expectParse('"a\$\{1\}b', 'STUB STRING INTERPOLATION');
  });

  // Identifiers

  test('should punt on library identifiers', () {
    BVT.expectParse('lib.name', 'stubIDENTIFIER_lib.name');
  });

  test('should punt on prefix identifiers', () {
    BVT.expectParse('prefix.name', 'stubIDENTIFIER_prefix.name');
  });

  test('should punt on simple identifiers', () {
    BVT.expectParse('id', 'stubIDENTIFIER_id');
  });

  // Binary expressions

  test('should parse binary expressions', () {
    BVT.expectParse('3 + 4', '3 + 4');
  });

  // Cascade expressions
  test('should parse cascade expressions', () {
    BVT.expectParse('x.foo()..boo()', 'CASCADES NOT IMPLEMENTED');
  });

  // Conditional expressions
  test('should parse conditional expressions', () {
    BVT.expectParse('true ? 4 : 3', 'true ? 4 : 3');
  });

  // Function expressions
  test('should parse function expressions', () {
    BVT.expectParse('x()', 'stubIDENTIFIER_x()');
  });

  test('should parse function expressions with parameters', () {
    BVT.expectParse('x(1,2)', 'stubIDENTIFIER_x(1, 2)');
  });

  test('should parse method expressions', () {
    BVT.expectParse('b.x(1,2)',
      'stubIDENTIFIER_b.stubIDENTIFIER_x(1, 2)');
  });

  // Index expressions
  test('should parse index expressions', () {
    BVT.expectParse('x[2]', 'stubIDENTIFIER_x[2]');
  });

  // Instance creatation expessions
  test('should parse a new call', () {
    BVT.expectParse('new Y()', 'new stubIDENTIFIER_Y()');
  });

  test('should parse parans', () {
    BVT.expectParse('4 * (2 + 2)', '4 * (2 + 2)');
  });

  // NOTE: the JS AST doesn't have parans and will remove
  // unneeded ones.
  test('should parse parans', () {
    BVT.expectParse('(4) * ((2 + 2))', '4 * (2 + 2)');
  });

  test('should parse postfix expressions', () {
    BVT.expectParse('i++', 'stubIDENTIFIER_i++');
  });

  test('should parse prefix expressions', () {
    BVT.expectParse('++i', '++stubIDENTIFIER_i');
  });

  // Property access
  test('should parse property access', () {
    BVT.expectParse('a[4].b', 'stubIDENTIFIER_a[4].stubIDENTIFIER_b');
  });

  // this
  test('should parse this', () {
    BVT.expectParse('this', 'this');
  });

  // throw
  // TODO(deboer): Investigate.  In JS, throw is a statement.
  //test('should parse throw', () {
  //  BVT.expectParse('throw 5', 'throw 5');
  //});

  // is expression
  test('should parse is', () {
    BVT.expectParse('4 is int', 'typeof 4 == stubIDENTIFIER_int');
  });

  test('should parse is not', () {
    BVT.expectParse('4 is ! int', 'typeof 4 != stubIDENTIFIER_int');
  });

  // assignments
  test('should parse assignments', () {
    BVT.expectParse('f = 5', 'stubIDENTIFIER_f = 5');
  });

  test('should compound parse assignments', () {
    BVT.expectParse('f *= 5', 'stubIDENTIFIER_f *= 5');
  });
}

