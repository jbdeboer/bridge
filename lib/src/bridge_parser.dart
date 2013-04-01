/**
* Takes a Dart file as a string and returns a Javascript
* string.
*
*/

import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';


import 'package:unittest/unittest.dart';
import 'bridge_visitor.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';

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
