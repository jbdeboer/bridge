import 'package:unittest/unittest.dart';
import './../lib/src/analyzer_experimental/ast.dart';


import '../lib/src/identifier_visitor.dart';
import '../lib/src/parse.dart';
import '../lib/src/lexical_scope.dart';
import '../lib/src/base_visitor.dart';
import '../lib/src/type_factory.dart';

import './../lib/src/analyzer_experimental/ast.dart' as dart;
import './../lib/src/analyzer_experimental/scanner.dart' as scanner;
import './../lib/src/analyzer_experimental/element.dart' as element;


final element.Type2 ARRAY_TYPE = typeFactory('List', []);
final element.Type2 STRING_TYPE = typeFactory('String');

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

  test('should return a prefixed identifier with no scope', () {
    expectId('b.a', 'b.a');
  });

  test('should return a prefixed identifier with scope', () {
    var scope = new LexicalScope();
    scope.currentScope = LexicalScope.CLASS;
    scope.addName('a');
    scope.addName('b');

    expectId('b.a', 'this.b.a', scope);
  });

  test('should return Math.sqrt for sqrt', () {
    expectId('sqrt', 'Math.sqrt');
  });

  test('should not rename a sqrt method', () {
    expectId('b.sqrt', 'b.sqrt');
  });

  test('should rename an add method to push for Arrays', () {
    var scope = new LexicalScope();
    scope.currentScope = LexicalScope.METHOD;
    scope.currentType = ARRAY_TYPE;

    expectId('add', 'push', scope);
  });

  test('should not rename an add method to push for Strings', () {
    var scope = new LexicalScope();
    scope.currentScope = LexicalScope.METHOD;
    scope.currentType = STRING_TYPE;

    expectId('add', 'add', scope);
  });

  test('should not rename an add metod for non Arrays', () {
    expectId('add', 'add');
  });
}
