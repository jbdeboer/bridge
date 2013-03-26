
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
import 'generated/test_support.dart';

class Hello {
/**
   * Parse the given source as a compilation unit.
   * @param source the source to be parsed
   * @param errorCodes the error codes of the errors that are expected to be found
   * @return the compilation unit that was parsed
   * @throws Exception if the source could not be parsed, if the compilation errors in the source do
   * not match those that are expected, or if the result would have been {@code null}
   */
static CompilationUnit parseCompilationUnit(String source) {
GatheringErrorListener listener = new GatheringErrorListener();
StringScanner scanner = new StringScanner(null, source, listener);
listener.setLineInfo(new TestSource(), scanner.lineStarts);
Token token = scanner.tokenize();
Parser parser = new Parser(null, listener);
CompilationUnit unit = parser.parseCompilationUnit(token);
//JUnitTestCase.assertNotNull(unit);
//listener.assertErrors2(errorCodes);
return unit;
}


}

main() {
  print('Printing hello');

  Node node = Hello.parseCompilationUnit('class R {}');

  PrintStringWriter writer = new PrintStringWriter();
  node.accept(new ToSourceVisitor(writer));

  print(writer.toString());

}
