import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';


import 'package:unittest/unittest.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';

import '../lib/src/jsast/js.dart' as js;

import '../lib/src/class_member_visitor.dart';
import '../lib/src/listeners.dart';
import '../lib/src/parse.dart';
import '../lib/src/stub_visitor.dart';
import '../lib/src/utils.dart';


stringBridge(String dart) {
  PrintStringWriter psw = new PrintStringWriter();
  ASTNode n = parseText(dart);
  var visitor = new ClassMemberVisitor(new StubVisitor());
  ;
  for (var s in n.accept(visitor)) {
      psw.print(js.prettyPrint(s).getText());
    }
  return psw.toString();
}

class BVT {
 static expectParse(String dart, String jsCode) {
    expect(stringBridge(dart), equals(jsCode));
 }
}

main() {
  test('should parse a simple class', () {
    BVT.expectParse(
        'class E { String x; }',
        // JS.
        dedent("""
           /**
            * @constructor
            */
           function E() {
           }
           /** @type {string} */
           E.prototype.x;
           """
        ));
  });


  test('should parse a class with a constructor', () {
    BVT.expectParse(dedent("""
        class C {
          String x;
          C(this.x);
        }"""),
    // JS.
    dedent("""
        /\**
         * @constructor
         */
        function C(x) {
          this.x = x;
        }
        /\** @type {string} */
        C.prototype.x;
        """));
  });

  test('should parse a class with a method', () {
    BVT.expectParse(dedent("""
        class C {
          String method() { return "a"; };
        }"""),
    // JS.
    dedent("""
        /\**
         * @constructor
         */
        function C() {
        }
        /\**
         * @return {string}
         */
        C.prototype.method = function()
          // STUB BLOCK
        ;
         """));
  });
}
