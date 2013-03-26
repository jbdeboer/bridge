part of dart2closure;

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


CompilationUnit parseFile(File file) {
  var text = file.readAsStringSync();
  return parseText(text);
}
