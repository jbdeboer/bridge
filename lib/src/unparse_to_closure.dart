import 'package:analyzer_experimental/src/generated/ast.dart';

// From this package.
import 'debug.dart';
import 'symbols.dart';
import 'utils.dart';
import 'unparse_to_closure/block_visitor.dart';


void unparseToClosureJs(CompilationUnit ast) {
  var instanceScope = new Scope();
  var currentScope = new Scope();
  var buffer = new IndentedStringBuffer();
  var blockVisitor = new BlockVisitor(currentScope: currentScope,
                                      instanceScope: instanceScope,
                                      buffer: buffer);
  ast.accept(blockVisitor);
  return buffer.toString();
}
