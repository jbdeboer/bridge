import './analyzer_experimental/ast.dart';

// From this package.
import 'debug.dart';
import 'stub_visitor.dart';
import 'symbols.dart';
import 'utils.dart';
import 'unparse_to_closure/block_visitor.dart';


String unparseToClosureJs(CompilationUnit ast) {
  var currentScope = new Scope();
  var buffer = new IndentedStringBuffer();
  var blockVisitor = new BlockVisitor(currentScope,
                                      buffer,
                                      new StubVisitor());
  ast.accept(blockVisitor);
  return buffer.toString();
}
