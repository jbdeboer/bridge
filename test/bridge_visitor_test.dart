library engine.bridge_visitor_test;

import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';


import 'generated/test_support.dart';
import 'package:unittest/unittest.dart';
import '../lib/src/bridge_visitor.dart';
import '../lib/src/generated/ast.dart';
import '../lib/src/generated/scanner.dart';
import '../lib/src/generated/error.dart';
import '../lib/src/generated/parser.dart';

class BVT {
  static Comment comment() =>
    Comment.createBlockComment([Keyword.BREAK]);

static CompilationUnit parseCompilationUnit(String source) {
GatheringErrorListener listener = new GatheringErrorListener();
StringScanner scanner = new StringScanner(null, source, listener);
listener.setLineInfo(new TestSource(), scanner.lineStarts);
Token token = scanner.tokenize();

Token t1 = token;
while (t1.type != TokenType.EOF) {
  print('First: ${t1.type.toString()} comment: ${t1.precedingComments}');
  t1 = t1.next;
}
print('Last: ${t1.type.toString()} comment: ${t1.precedingComments}');


Parser parser = new Parser(null, listener);
CompilationUnit unit = parser.parseCompilationUnit(token);
//JUnitTestCase.assertNotNull(unit);
//listener.assertErrors2(errorCodes);
return unit;
}

static expectParse(String dart, String js) {
  PrintStringWriter psw = new PrintStringWriter();
  BridgeVisitor bv = new BridgeVisitor(psw);
  ASTNode n = BVT.parseCompilationUnit(dart);
  n.accept(new BridgeVisitor(psw));
  expect(psw.toString(), equals(js));
}
}

main() {



  test('5 should equal 5', () =>
    expect(5, equals(5)));

  test('construct a BridgeVisitor', () =>
    expect(new BridgeVisitor(new PrintStringWriter()), isNotNull));

  test('should parse an simple node', () {
    PrintStringWriter psw = new PrintStringWriter();
    BridgeVisitor bv = new BridgeVisitor(psw);
    ASTNode n = BVT.parseCompilationUnit('var r; ');
    n.accept(bv);
    expect(psw.toString(), equals("var r"));
  });

  test('should parse a variable assignment', () {
    BVT.expectParse('var r = 3', 'var r = 3');
  });

  test('should parse a typed variable assignment', () {
    BVT.expectParse('String r = "a"',
      '/\** @type {string} */\n' +
      'var r = "a"');
  });
}
