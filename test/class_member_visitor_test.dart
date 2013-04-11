import 'package:unittest/unittest.dart';

import '../lib/src/class_member_visitor.dart';
import '../lib/src/parse.dart';
import '../lib/src/utils.dart';


expectClass(String dart, String jsCode) {
  expect(stringBridge(dart, (x) => new ClassMemberVisitor(x), identityQuery, true),
         equals(dedent(jsCode)));
}

expectClassRaises(String dart) => expect(() => expectClass(dart, ""), throws);

main() {
  test('should parse a simple class', () {
    expectClass('class E { String x; }',
        // JS.
        """
           /**
            * @constructor
            */
           function E() {
           }
           /** @type {string} */
           E.prototype.x;
           """
        );
  });

  test('should parse a simple class with an int', () {
    expectClass('class E { int x; }',
// JS.
    """
           /**
            * @constructor
            */
           function E() {
           }
           /** @type {number} */
           E.prototype.x;
           """
    );
  });


  test('should parse a class with a constructor', () {
    expectClass("""
        class C {
          String x;
          C(this.x);
        }""",
    // JS.
    """
        /**
         * @constructor
         */
        function C(x) {
          this.x = x;
        }
        /** @type {string} */
        C.prototype.x;
        """);
  });

  test('should parse a class with a constructor with two constructors', () {
    expectClassRaises("""
        class C {
          C(this.x, this.y);
          C.a();
        }""");
  });


  test('should parse a class with a method', () {
    expectClass("""
        class C {
          String method() { return "a"; };
        }""",
    // JS.
    """
        /**
         * @constructor
         */
        function C() {
        }
        /**
         * @return {string}
         */
        C.prototype.method = function() {
          // STUB FUNCTION BODY scope:{method: 2}
        };
         """);
  });

  test('should parse a class with a method that returns an int', () {
    expectClass("""
        class C {
          int method() { return 4; };
        }""",
// JS.
    """
        /**
         * @constructor
         */
        function C() {
        }
        /**
         * @return {number}
         */
        C.prototype.method = function() {
          // STUB FUNCTION BODY scope:{method: 2}
        };
         """);
  });

  test('should parse a class with a method with a parameter', () {
    expectClass('class C { p(x) {}; }', """
        /**
         * @constructor
         */
        function C() {
        }
        /**
         * @return {?}
         */
        C.prototype.p = function(x) {
          // STUB FUNCTION BODY scope:{p: 2}
        };
        """);
  });

  test('should parse a class with methods in any order', () {
    expectClass('class C { f() {}; p(x) {}; }', """
        /**
         * @constructor
         */
        function C() {
        }
        /**
         * @return {?}
         */
        C.prototype.f = function() {
          // STUB FUNCTION BODY scope:{p: 2, f: 2}
        };
        /**
         * @return {?}
         */
        C.prototype.p = function(x) {
          // STUB FUNCTION BODY scope:{p: 2, f: 2}
        };
        """);
  });

}
