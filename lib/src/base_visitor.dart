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
    print("get other: scope:${scope != null}");
    return otherVisitorFactory(this);
  }

  BaseVisitor(BaseVisitorOptions options) {
    if (options == null) return;
    this.otherVisitorFactory = options.otherVisitorFactory;
    this.scope = options.scope;
  }

  List<js.Node> visitCompilationUnit(CompilationUnit node) {
    var ret = new List<js.Node>();
    for (var child in node.sortedDirectivesAndDeclarations) {
      ret.addAll(child.accept(this));
    }
    return ret;
  }
}
