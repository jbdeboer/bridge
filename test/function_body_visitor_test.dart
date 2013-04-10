import 'package:unittest/unittest.dart';
import './../lib/src/analyzer_experimental/ast.dart';

import '../lib/src/function_body_visitor.dart';
import '../lib/src/parse.dart';

expectFunctionBody(String dart, String jsCode) {
  expect(
      stringBridge("main() $dart", (x) => new FunctionBodyVisitor(x),
          (node) => node.sortedDirectivesAndDeclarations[0].functionExpression.body),
       equals(jsCode));
}

main() {
  test('should accept an empty function body', () {
    expectFunctionBody('', '{\n}\n');
  });

  test('should accept a function body', () {
    expectFunctionBody('{}', '{\n  // STUB BLOCK\n}\n');
  });
}
