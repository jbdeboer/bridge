import 'package:unittest/unittest.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';

import '../lib/src/bridge_visitor.dart';
import '../lib/src/lexical_scope.dart';
import '../lib/src/parse.dart';

ASTNode identityQuery(node) => node;

class FakeVisitor {
  FakeVisitor(this.scope);
  LexicalScope scope;
}

expectDart(String dart, String jsCode, [ASTNode query(ASTNode) = identityQuery, otherVisitor]) {

  expect(stringBridge(dart, (x) => new BridgeVisitor(otherVisitor), query), equals(jsCode));
}

main() {
  test('should call Identifier Visitor', () {
    expectDart('X x = 3', 'X',
        (node) => node.sortedDirectivesAndDeclarations[0].variables.type.name );
  });

  test('should pass scope to Identifier Visitor', () {
    LexicalScope scope = new LexicalScope();
    scope.currentScope = LexicalScope.CLASS;
    scope.addName('X');

    expectDart('X x = 3', 'this.X',
        (node) => node.sortedDirectivesAndDeclarations[0].variables.type.name,
        new FakeVisitor(scope));
  });
}
