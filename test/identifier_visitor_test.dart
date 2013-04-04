import 'package:unittest/unittest.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';


import '../lib/src/identifier_visitor.dart';
import '../lib/src/parse.dart';
import '../lib/src/lexical_scope.dart';
import '../lib/src/base_visitor.dart';

queryId(CompilationUnit node) =>
    node.sortedDirectivesAndDeclarations[0].
       variables.type.name;



expectId(String dart, String jsCode, [LexicalScope optScope]) {
  var scope = optScope == null ? new LexicalScope() : optScope;
  expect(stringBridge("$dart x = null", (x) => new IdentifierVisitor(new BaseVisitorOptions(x, scope)), queryId),
  equals(jsCode));
}

main() {
  test('should return a simple identifier with no scope', () {
    expectId('a', 'a');
  });

  test('should return a class id', () {
    var scope = new LexicalScope();
    scope.currentScope = LexicalScope.CLASS;
    scope.addName('a');
    expectId('a', 'this.a', scope);
  });
}
