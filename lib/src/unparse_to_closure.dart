import 'package:analyzer_experimental/src/generated/ast.dart';

// From this package.
import '../lib/src/debug.dart';
import '../lib/src/symbols.dart';
import '../lib/src/unparse_to_closure/block_visitor.dart';
import '../lib/src/utils.dart';


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
