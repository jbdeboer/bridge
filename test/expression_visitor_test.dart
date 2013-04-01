import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';


import 'package:unittest/unittest.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';

import '../lib/listeners.dart';
import '../lib/parse.dart';
import '../lib/utils.dart';

import '../lib/src/expression_visitor.dart';
import '../lib/src/stub_visitor.dart';
import '../lib/src/jsast/js.dart' as js;


stringBridge(String dart) {
  PrintStringWriter psw = new PrintStringWriter();
  ASTNode n = parseText(dart);
  var visitor = new ExpressionVisitor(new StubVisitor());

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

main() { /*
  test('should parse string literals', () {
    BVT.expectParse('"A"', '"A"');
  }); */
}

