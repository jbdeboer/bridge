import 'package:analyzer_experimental/src/generated/ast.dart';
import 'lexical_scope.dart';
import 'jsast/js.dart' as js;

class BaseVisitorOptions {
  BaseVisitorOptions(this.otherVisitorFactory, this.scope);

  var otherVisitorFactory;
  LexicalScope scope;
}

class BaseVisitor implements ASTVisitor<List<js.Node>> {
  var otherVisitorFactory;
  LexicalScope scope;

  BaseVisitor get otherVisitor {
    return otherVisitorFactory(this);
  }

  BaseVisitor(BaseVisitorOptions options) {
    if (options == null) return;
    this.otherVisitorFactory = options.otherVisitorFactory;
    this.scope = options.scope;
  }

  List<js.Node> visitCompilationUnit(CompilationUnit node) {
    var ret = new List<js.Node>();
    if (node.directivesAreBeforeDeclarations()) {
      node.directives.elements.forEach((x) => ret.addAll(x.accept(this)));
      node.declarations.elements.forEach((x) => ret.addAll(x.accept(this)));
      return ret;
    }
    for (var child in node.sortedDirectivesAndDeclarations) {
      ret.addAll(child.accept(this));
    }
    return ret;
  }
}
