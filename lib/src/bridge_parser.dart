/**
* Takes a Dart file as a string and returns a Javascript
* string.
*
*/

import './analyzer_experimental/java_core.dart';
import './analyzer_experimental/java_engine.dart';
import './analyzer_experimental/java_junit.dart';


import 'package:unittest/unittest.dart';
import 'bridge_visitor.dart';
import './analyzer_experimental/ast.dart';
import './analyzer_experimental/scanner.dart';
import './analyzer_experimental/error.dart';
import './analyzer_experimental/parser.dart';

import 'listeners.dart';
import 'parse.dart';
import 'utils.dart';

stringBridge(String dart) {
  PrintStringWriter psw = new PrintStringWriter();
  BridgeVisitor bv = new BridgeVisitor(psw);
  ASTNode n = parseText(dart);
  n.accept(new BridgeVisitor(psw));
  return psw.toString();
}
