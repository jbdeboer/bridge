part of dart2closure;

class DumpAstVisitor extends GeneralizingASTVisitor {
  var _indentLevel = 0;
  StringBuffer _buffer;

  DumpAstVisitor(StringBuffer buffer) {
    this._buffer = buffer;
  }

  getIndentString() {
    var indent = '';
    for (var i = 0; i < this._indentLevel; i++) {
      indent += '  ';
    }
    return indent;
  }

  visitChildren(ASTNode node) {
    this._indentLevel++;
    var result = node.visitChildren(this);
    this._indentLevel--;
    return result;
  }

  visitNode(ASTNode node) {
    // TODO(chirayu): Use a writer so that dumpAst() can be changed to return a string.
    this._buffer.writeln('${this.getIndentString()}${node.runtimeType}: ${node.toString()}');
    return this.visitChildren(node);
  }

  static dumpAst(CompilationUnit node) {
    StringBuffer buffer = new StringBuffer();
    node.accept(new DumpAstVisitor(buffer));
    return buffer.toString();
  }
}


var dumpAst = DumpAstVisitor.dumpAst;
