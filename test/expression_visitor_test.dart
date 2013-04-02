import 'package:unittest/unittest.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';

import '../lib/src/expression_visitor.dart';
import '../lib/src/parse.dart';


queryExpression(node) =>
  node.sortedDirectivesAndDeclarations[0].
        variables.variables[0].initializer;

expectExpr(String dart, String jsCode) {
  expect(stringBridge("var x = $dart",
      (x) => new ExpressionVisitor(x),
      queryExpression),
    equals(jsCode));
}

main() {
  // Basic literals.
  test('should parse string literals', () {
    expectExpr('"A"', '"A"');
  });

  test('should parse integers', () {
    expectExpr('4', '4');
  });

  test('should parse doubles', () {
    expectExpr('4.3', '4.3');
  });

  test('should parse booleans', () {
    expectExpr('true', 'true');
  });

  test('should parse null literals', () {
    expectExpr('null', 'null');
  });



  // Typed literals.
  test('should parse list literals', () {
    expectExpr('[]', '[]');
  });

  test('should parse list literals', () {
    expectExpr('[1,2]', '[1, 2]');
  });

  test('should parse map literals', () {
    expectExpr('{}', '{}');
  });

  test('should parse map literals with properties', () {
    expectExpr('{"a":1, "b":2}', '{a: 1, b: 2}');
  });



  // String literals.
  test('should parse adjacent strings', () {
    expectExpr('"a" "b"', '"a" + "b"');
  });

  test('should parse string interpolation', () {
    expectExpr('"a\$\{1\}b', 'STUB STRING INTERPOLATION');
  });



  // Identifiers
  test('should punt on library identifiers', () {
    expectExpr('lib.name', 'stubIDENTIFIER_lib.name');
  });

  test('should punt on prefix identifiers', () {
    expectExpr('prefix.name', 'stubIDENTIFIER_prefix.name');
  });

  test('should punt on simple identifiers', () {
    expectExpr('id', 'stubIDENTIFIER_id');
  });



  // Binary expressions
  test('should parse binary expressions', () {
    expectExpr('3 + 4', '3 + 4');
  });



  // Cascade expressions
  test('should parse cascade expressions', () {
    expectExpr('x.foo()..boo()', 'CASCADES NOT IMPLEMENTED');
  });



  // Conditional expressions
  test('should parse conditional expressions', () {
    expectExpr('true ? 4 : 3', 'true ? 4 : 3');
  });



  // Function expressions
  test('should parse function expressions', () {
    expectExpr('x()', 'stubIDENTIFIER_x()');
  });

  test('should parse function expressions with parameters', () {
    expectExpr('x(1,2)', 'stubIDENTIFIER_x(1, 2)');
  });

  test('should parse method expressions', () {
    expectExpr('b.x(1,2)',
      'stubIDENTIFIER_b.stubIDENTIFIER_x(1, 2)');
  });



  // Index expressions
  test('should parse index expressions', () {
    expectExpr('x[2]', 'stubIDENTIFIER_x[2]');
  });



  // Instance creatation expessions
  test('should parse a new call', () {
    expectExpr('new Y()', 'new stubIDENTIFIER_Y()');
  });

  test('should parse parans', () {
    expectExpr('4 * (2 + 2)', '4 * (2 + 2)');
  });



  // NOTE: the JS AST doesn't have parans and will remove
  // unneeded ones.
  test('should parse parans', () {
    expectExpr('(4) * ((2 + 2))', '4 * (2 + 2)');
  });

  test('should parse postfix expressions', () {
    expectExpr('i++', 'stubIDENTIFIER_i++');
  });

  test('should parse prefix expressions', () {
    expectExpr('++i', '++stubIDENTIFIER_i');
  });



  // Property access
  test('should parse property access', () {
    expectExpr('a[4].b', 'stubIDENTIFIER_a[4].stubIDENTIFIER_b');
  });



  // this
  test('should parse this', () {
    expectExpr('this', 'this');
  });



  // throw
  // TODO(deboer): Investigate.  In JS, throw is a statement.
  //test('should parse throw', () {
  //  expectExpr('throw 5', 'throw 5');
  //});



  // is expression
  test('should parse is', () {
    expectExpr('4 is int', 'typeof 4 == stubIDENTIFIER_int');
  });

  test('should parse is not', () {
    expectExpr('4 is ! int', 'typeof 4 != stubIDENTIFIER_int');
  });



  // assignments
  test('should parse assignments', () {
    expectExpr('f = 5', 'stubIDENTIFIER_f = 5');
  });

  test('should compound parse assignments', () {
    expectExpr('f *= 5', 'stubIDENTIFIER_f *= 5');
  });
}

