import 'package:unittest/unittest.dart';
import '../lib/src/lexical_scope.dart';

main() {
  test('should return unqualified name for unknown name', () {
    LexicalScope scope = new LexicalScope();
    expect(scope.nameFor('unknown'), equals('unknown'));
  });

  test('should return class name for when set', () {
    LexicalScope scope = new LexicalScope();
    scope.currentScope = LexicalScope.CLASS;
    scope.addName('c');
    expect(scope.nameFor('c'), equals('this.c'));
  });

  test('should support shadowing', () {
    LexicalScope scope = new LexicalScope();
    scope.currentScope = LexicalScope.CLASS;
    scope.addName('c');
    scope.currentScope = LexicalScope.UNQUALIFIED;
    scope.addName('c');
    expect(scope.nameFor('c'), equals('c'));
  });

  test('should support cloning', () {
    LexicalScope scope = new LexicalScope();
    var childA = new LexicalScope.clone(scope);
    var childB = new LexicalScope.clone(scope);

    scope.currentScope = LexicalScope.UNQUALIFIED;
    scope.addName('x');
    childA.currentScope = LexicalScope.CLASS;
    childA.addName('x');
    childB.addName('y');

    expect(scope.nameFor('x'), equals('x'));
    expect(childA.nameFor('x'), equals('this.x'));
    expect(childB.nameFor('x'), equals('x'));
    expect(childB.nameFor('y'), equals('y'));
  });
}
