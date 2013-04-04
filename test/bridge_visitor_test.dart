import 'package:unittest/unittest.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';

import '../lib/src/bridge_visitor.dart';
import '../lib/src/lexical_scope.dart';
import '../lib/src/parse.dart';
import '../lib/src/utils.dart';
import '../lib/src/base_visitor.dart';

ASTNode identityQuery(node) => node;

class FakeVisitor extends BaseVisitor {
  FakeVisitor(scope) : super(null) {
    if (scope != null) { this.scope = scope; }
    else this.scope = new LexicalScope();
  }
  LexicalScope scope;
}

expectDart(String dart, String jsCode, [ASTNode query(ASTNode) = identityQuery, LexicalScope scope]) {
  expect(stringBridge(dart, (x) => new BridgeVisitor(new FakeVisitor(scope)), query), equals(dedent(jsCode)));
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

    print("passed scope");
    expectDart('X x = 3', 'this.X',
        (node) => node.sortedDirectivesAndDeclarations[0].variables.type.name,
        scope);
  });

  test('should call ExpressionVisitor', () {
    expectDart('var x = 3 + y', '3 + y',
    (node) => node.sortedDirectivesAndDeclarations[0].
        variables.variables[0].initializer);
  });

  test('should call ExpressionVisitor with scope', () {
    LexicalScope scope = new LexicalScope();
    scope.currentScope = LexicalScope.CLASS;
    scope.addName('y');

    expectDart('var x = 3 + y', '3 + this.y',
        (node) => node.sortedDirectivesAndDeclarations[0].
    variables.variables[0].initializer, scope);
  });

  test('should call Block Visitor', () {
    expectDart('main() { var x; }', '{\n  var x;\n}\n',
        (node) => node.declarations[0].functionExpression.body.block);
  });

  test('should call Class Visitor', () {
    expectDart('class C { }', """
    /**
     * @constructor
     */
    function C() {
    }
    """);
  });
}
