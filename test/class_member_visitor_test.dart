import 'package:unittest/unittest.dart';

import '../lib/src/class_member_visitor.dart';
import '../lib/src/parse.dart';
import '../lib/src/utils.dart';


expectClass(String dart, String jsCode) {
  expect(stringBridge(dart, (x) => new ClassMemberVisitor(x)),
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
          // STUB BLOCK
        };
         """);
  });
}
