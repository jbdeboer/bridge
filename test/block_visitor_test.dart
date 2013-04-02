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

expectBlock(String dart, String jsCode) {
  dart = dedent(dart);
  jsCode = dedent(jsCode);
  expect(stringBridge("main() $dart",
      (x) => new BlockVisitor.root(x),
      queryBlock).trim(),
    equals(jsCode));
}

main() {
  test('should parse a simple block', () {
    expectBlock(
        '{}',
        // JS.
        "{\n}"
        );

    expectBlock(
        """
        {
          var a;
        }""",
        // JS.
        """
        {
          var stubIDENTIFIER_a;
        }"""
        );

  });
}
