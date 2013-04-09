library debug;

import 'dart:mirrors';

import './analyzer_experimental/ast.dart';
import 'utils.dart';


class TreeIndentedWriter extends IndentedStringBuffer {
  String getIndentAtLevel(num l) {
    if (l + 1 == level) {
      return '├── ';
    } else {
      return '│   ';
    }
  }

  String getIndentString(num level) {
    return new List<String>.generate(level, getIndentAtLevel).join();
  }
}


class DumpAstVisitor extends GeneralizingASTVisitor {
  var buffer;

  DumpAstVisitor(this.buffer);

  visitChildren(ASTNode node) {
    var result = node.visitChildren(this);
    return result;
  }

  visitNode(ASTNode node) {
    try {
      var snippet = node.toString();
      if (snippet.length > 25) {
        snippet = '${snippet.slice(0, 10)}...';
      }
      buffer.writeln('${node.runtimeType}: ${snippet}');
      assert(node.runtimeType.toString() == reflect(node).type.simpleName);
      buffer.level++;
      return this.visitChildren(node);
    }
    finally {
      buffer.level--;
    }
  }

  static dumpAst(CompilationUnit node) {
    var buffer = new TreeIndentedWriter();
    // var buffer = new IndentedStringBuffer();
    node.accept(new DumpAstVisitor(buffer));
    return buffer.toString();
  }
}

var dumpAst = DumpAstVisitor.dumpAst;
