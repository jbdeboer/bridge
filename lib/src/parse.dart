library parse;


import './analyzer_experimental/ast.dart';
import './analyzer_experimental/parser.dart';
import './analyzer_experimental/scanner.dart';

// Package local imports.
import 'base_visitor.dart';
import 'debug.dart';
import 'lexical_scope.dart';
import 'listeners.dart';
import 'stub_visitor.dart';
import 'visit_result.dart';
import 'type_translator.dart';

import 'jsast/js.dart' as js;

CompilationUnit parseText(String text) {
 // List<ErrorCode> errorCodes;
  ErrorListener errorListener = new ErrorListener();
  StringScanner scanner = new StringScanner(null, text, errorListener);
  Token token = scanner.tokenize();
  Parser parser = new Parser(null, errorListener);
  CompilationUnit unit = parser.parseCompilationUnit(token);
  // TODO(chirayu): When is "errorCodes" valid?
  return unit;
}

ASTNode identityQuery(node) => node;
class TypedBridgeOutput {
  String jsCode;
  String jsType;
  TypedBridgeOutput(this.jsCode, this.jsType);
}



TypedBridgeOutput typedStringBridge(String dart,
                    BaseVisitor visitorFactory(BaseVisitor),
                    [ASTNode query(ASTNode) = identityQuery, printScope = false]) {
  ASTNode n = parseText(dart);
  var visitor = visitorFactory(new BaseVisitorOptions((x) => new StubVisitor(x.scope, printScope), new LexicalScope()));

  VisitResult nodes = query(n).accept(visitor);
  // TODO: create a new top-level JS AST node.
  return new TypedBridgeOutput(
      nodes.nodes.map((s) => js.prettyPrint(s).getText()).join(""),
      dartTypeToJsType(nodes.type));
}

String stringBridge(String dart,
                    BaseVisitor visitorFactory(BaseVisitor),
                    [ASTNode query(ASTNode) = identityQuery, printScope = false]) => typedStringBridge(dart, visitorFactory, query, printScope).jsCode;
