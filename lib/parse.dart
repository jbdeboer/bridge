import 'dart:io';

import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';

// Package local imports.
import 'package:dart2closure/listeners.dart';


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


CompilationUnit parseStream(Stream stream) {
  var text = file.readAsStringSync();
  return parseText(text);
}


CompilationUnit parseFile(File file) {
  var text = file.readAsStringSync();
  return parseText(text);
}
