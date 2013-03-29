import 'package:analyzer_experimental/src/generated/ast.dart';

// From this package.
import '../lib/debug.dart';
import '../lib/symbols.dart';
import '../lib/unparse_to_closure/block_visitor.dart';
import '../lib/utils.dart';


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
