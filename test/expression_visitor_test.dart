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
}

