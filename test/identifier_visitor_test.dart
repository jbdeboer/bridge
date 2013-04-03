import 'package:unittest/unittest.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';


import '../lib/src/identifier_visitor.dart';
import '../lib/src/parse.dart';

queryId(CompilationUnit node) =>
    node.sortedDirectivesAndDeclarations[0].
       variables.type.name;

expectId(String dart, String jsCode) {
  expect(stringBridge("$dart x = null", (x) => new IdentifierVisitor(x), queryId),
  equals(jsCode));
}

main() {
  test('should return a simple identifier with no scope', () {
    expectId('a', 'a');
  });
}