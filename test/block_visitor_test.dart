import './../lib/src/analyzer_experimental/ast.dart';
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
  expect(dartToJs(dart), equals(dedent(jsCode).trim()));
}

expectBlockRaises(String dart) {
  expect(() => dartToJs(dart), throws);
}

main() {
  // Empty block.
  test('should parse a simple block', () {
    expectBlock(
        '{}',
        // JS.
        "{\n}"
        );
  });

  // var a;
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


  test('should parse a simple function defintion', () {
    expectBlock('{ g() { }; }', """
    {
      /**
     * jsdoc TODO
     */
    function g() {
        // STUB FUN
      }
      ;
    }""");
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

  // a = 1.
  test('should parse a simple var initialization', () {
    expectBlock(
        """
        {
          var a = 1;
        }""",
        // JS.
        """
        {
          var a = 1-stubEXPR;
        }"""
        );
  });

  // a = b.
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

  // Break statement.
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

  // Continue statement.
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

  // Return statement.
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

  test('should emit a return statement with an expression', () {
    expectBlock(
        """
        {
          return x;
        }""",
// JS.
        """
        {
          return stubIDENTIFIER_x;
        }"""
    );
  });


  // if (true);
  test('should parse a simple if statement', () {
    expectBlock(
        """
        {
          if (true);
        }""",
        // JS.
        """
        {
          if (true-stubEXPR) {
            ;
          }
        }"""
        );
  });

  // if (true); else ;
  test('should parse a simple if /else statement', () {
    expectBlock(
        """
        {
          if (true); else;
        }""",
        // JS.
        """
        {
          if (true-stubEXPR) {
            ;
          } else {
            ;
          }
        }"""
        );
  });

  // if (true) { var a = 1 };
  test('should parse a simple if statement initialization', () {
    expectBlock(
        """
        {
          if (true) {
            var a = 1;
          }
        }""",
        // JS.
        """
        {
          if (true-stubEXPR) {
            var a = 1-stubEXPR;
          }
        }"""
        );
  });

  // if (true) { var a = 1; } else { var b = 1; }
  test('should parse a simple if/else statement with initialization', () {
    expectBlock(
        """
        {
          if (true) {
            var a = 1;
          } else {
            var b = 1;
          }
        }""",
        // JS.
        """
        {
          if (true-stubEXPR) {
            var a = 1-stubEXPR;
          } else {
            var b = 1-stubEXPR;
          }
        }"""
        );
  });

  // assert(false);
  test('should throw on assertion failure', () {
    expectBlock(
        """
        {
          assert(false);
        }
        """,
        // JS.
        """
        {
          if (false-stubEXPR) {
            throw "Assertion failed for dart expression: assert (false);";
          }
        }
        """
        );
  });


  // while(true);
  test('should translate simple while loop', () {
    expectBlock(
        """
        {
          while(true);
        }
        """,
        // JS.
        """
        {
          while (true-stubEXPR) {
            ;
          }
        }
        """
        );
  });

  // while(a > 0) a = a - 1;
  test('should translate single statement while loop', () {
    expectBlock(
        """
        {
          while(notDone) continue;
        }
        """,
        // JS.
        """
        {
          while (stubIDENTIFIER_notDone) {
            continue;
          }
        }
        """
        );
  });

  // ExpressionStatements
  test('should translate expression statements', () {
    expectBlock('{ a; }', """
    {
      stubIDENTIFIER_a;
    }""");
  });
}
