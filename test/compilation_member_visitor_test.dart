import 'package:unittest/unittest.dart';
import './../lib/src/analyzer_experimental/ast.dart';

import '../lib/src/compilation_member_visitor.dart';
import '../lib/src/parse.dart';
import '../lib/src/utils.dart';

expectUnit(String dart, String jsCode) {
  expect(
      stringBridge(dart, (x) => new CompilationMemberVisitor(x),
          (node) => node.sortedDirectivesAndDeclarations[0]),
      equals(dedent(jsCode)));
}

main() {
  test('should accept a function declaration', () {
      expectUnit('main() { }', """
      /**
       * jsdoc TODO
       */
      function main() {
        // STUB FUN
      }
      """);
  });
}