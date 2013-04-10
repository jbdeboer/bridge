import 'package:unittest/unittest.dart';
import './../lib/src/analyzer_experimental/ast.dart';

import '../lib/src/function_body_visitor.dart';
import '../lib/src/parse.dart';

expectFunctionBody(String dart, String jsCode) {
  expect(stringBridge("main() $x", (x) => new FunctionBodyVisitor(x), (node) => node.body));
}

main() {
  test('should accept an empty function body', () {
    expectFunctionBody('', '{}');
  });
}
