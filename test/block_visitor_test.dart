import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:unittest/unittest.dart';

import '../lib/src/unparse_to_closure/block_visitor.dart';
import '../lib/src/parse.dart';
import '../lib/src/utils.dart';


Block queryBlock(CompilationUnit compilationUnit) {
  FunctionDeclaration declaration = compilationUnit.declarations[0];
  FunctionExpression expression = declaration.functionExpression;
  BlockFunctionBody body = expression.body;
  Block block = body.block;
  return block;
}

String dartToJs(String dart) {
  dart = dedent(dart);
  return stringBridge("main() $dart",
      (x) => new BlockVisitor.root(x),
      queryBlock).trim();
}

expectBlock(String dart, String jsCode) {
  expect(dartToJs(dart), equals(dedent(jsCode)));
}

expectBlockRaises(String dart) {
  expect(() => dartToJs(dart), throws);
}

main() {
  test('should parse a simple block', () {
    expectBlock(
        '{}',
        // JS.
        "{\n}"
        );
  });

  test('should parse a simple var defn', () {
    expectBlock(
        """
        {
          var a;
        }""",
        // JS.
        """
        {
          var a;
        }"""
        );
  });

  test('should throw on duplicate symbol definition', () {
    expectBlockRaises(
        """
        {
          var a;
          var a;
        }"""
        );
  });

  test('should parse a simple var initialization', () {
    expectBlock(
        """
        {
          var a = 1;
        }""",
        // JS.
        """
        {
          var a = 1 /* stubINT */;
        }"""
        );
  });

  test('should parse a simple var initialized from a non-literal', () {
    expectBlock(
        """
        {
          var a = b;
        }""",
        // JS.
        """
        {
          var a = stubIDENTIFIER_b;
        }"""
        );
  });

  test('should emit a break statement', () {
    expectBlock(
        """
        {
          break;
        }""",
        // JS.
        """
        {
          break;
        }"""
        );
  });

  test('should emit a continue statement', () {
    expectBlock(
        """
        {
          continue;
        }""",
        // JS.
        """
        {
          continue;
        }"""
        );
  });

  test('should emit a return statement', () {
    expectBlock(
        """
        {
          return;
        }""",
        // JS.
        """
        {
          return;
        }"""
        );
  });

}
