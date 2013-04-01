import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';


import 'package:unittest/unittest.dart';
import '../lib/src/bridge_visitor.dart';
import '../lib/src/bridge_parser.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';

import '../lib/listeners.dart';
import '../lib/parse.dart';
import '../lib/utils.dart';

class BVT {
  static expectParse(String dart, String js) {
    expect(stringBridge(dart), equals(js));
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
      '/** @type {string} */\n' +
      'var r = "a";');
  });



  test('should init vars with expression', () {
    BVT.expectParse('var dx = x - other.x;',
                    'var dx = this.x - other.x;');

  });
}
