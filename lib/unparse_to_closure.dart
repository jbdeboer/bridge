import 'package:analyzer_experimental/src/generated/ast.dart';

// From this package.
import 'package:dart2closure/debug.dart';
import 'package:dart2closure/symbols.dart';
import 'package:dart2closure/unparse_to_closure/block_visitor.dart';
import 'package:dart2closure/utils.dart';


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
