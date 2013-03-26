library engine.bridge_visitor_test;

import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';


import '../src/listeners.dart';
import '../src/parse.dart';
import 'package:unittest/unittest.dart';
import '../src/bridge_visitor.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';

class BVT {
  static Comment comment() =>
    Comment.createBlockComment([Keyword.BREAK]);

static expectParse(String dart, String js) {
  PrintStringWriter psw = new PrintStringWriter();
  BridgeVisitor bv = new BridgeVisitor(psw);
  ASTNode n = parseText(dart);
  n.accept(new BridgeVisitor(psw));
  expect(psw.toString(), equals(js));
}
}

main() {



  test('5 should equal 5', () =>
    expect(5, equals(5)));

  test('construct a BridgeVisitor', () =>
    expect(new BridgeVisitor(new PrintStringWriter()), isNotNull));

  /*test('should parse an simple node', () {
    BVT.expectParse('var r', 'var r');
  });*/

  test('should parse a variable assignment', () {
    BVT.expectParse('var r = 3', 'var r = 3;');
  });

  test('should parse a typed variable assignment', () {
    BVT.expectParse('String r = "a"',
      '/\** @type {string} */\n' +
      'var r = "a";');
  });

  test('should parse a simple class', () {
    BVT.expectParse('class E { String x; }',
"""/\**
 * @constructor
 */
function E() { }

/\** @type {string} */
E.prototype.x;"""
); });


  test('should parse a class with a constructor', () {
    BVT.expectParse("""class C {
  String x;
  C(this.x);
}""",
"""/\**
 * @constructor
 */
function C(x) {
  this.x = x;
}

/\** @type {string} */
C.prototype.x;"""); });


}
