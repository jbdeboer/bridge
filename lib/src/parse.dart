
import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';

// Package local imports.
import 'debug.dart';
import 'listeners.dart';
import 'base_visitor.dart';
import 'stub_visitor.dart';

import 'jsast/js.dart' as js;

CompilationUnit parseText(String text) {
  List<ErrorCode> errorCodes;
  ErrorListener errorListener = new ErrorListener();
  StringScanner scanner = new StringScanner(null, text, errorListener);
  Token token = scanner.tokenize();
  Parser parser = new Parser(null, errorListener);
  CompilationUnit unit = parser.parseCompilationUnit(token);
  // TODO(chirayu): When is "errorCodes" valid?
  return unit;
}

ASTNode identityQuery(node) => node;
String stringBridge(String dart,
                    BaseVisitor visitorFactory(BaseVisitor),
                    [ASTNode query(ASTNode) = identityQuery]) {
  ASTNode n = parseText(dart);
  var visitor = visitorFactory(() => new StubVisitor());

  List<js.Node> nodes = query(n).accept(visitor);
  return nodes.map((s) => js.prettyPrint(s).getText()).join("");
}
