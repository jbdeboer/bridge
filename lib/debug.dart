import 'dart:io';

import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:dart2closure/utils.dart';


class DumpAstVisitor extends GeneralizingASTVisitor {
  IndentedStringBuffer buffer;

  DumpAstVisitor(this.buffer);

  visitChildren(ASTNode node) {
    var result = node.visitChildren(this);
    return result;
  }

  visitNode(ASTNode node) {
    try {
      buffer.level++;
      var snippet = node.toString();
      if (snippet.length > 25) {
        snippet = '${snippet.slice(0, 10)}...';
      }
      buffer.writeln('${node.runtimeType}: ${snippet}');
      return this.visitChildren(node);
    }
    finally {
      buffer.level--;
    }
  }

  static dumpAst(CompilationUnit node) {
    var buffer = new IndentedStringBuffer();
    node.accept(new DumpAstVisitor(buffer));
    return buffer.toString();
  }
}

var dumpAst = DumpAstVisitor.dumpAst;
