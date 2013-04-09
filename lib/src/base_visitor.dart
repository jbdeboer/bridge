library base_visitor;

import './analyzer_experimental/ast.dart';

import 'jsast/js.dart' as js;

import 'lexical_scope.dart';
import 'visit_result.dart';


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

  // TODO(chirayu): Change to just return VisitResult when all callers can
  // handle it.
  VisitResult visitCompilationUnit(CompilationUnit node) {
    var ret = new VisitResult();
    var nodes = ret.nodes;
    if (node.directivesAreBeforeDeclarations()) {
      node.directives.elements.forEach((x) => nodes.addAll(
              x.accept(this)).nodes);
      node.declarations.elements.forEach(
          (x) => nodes.addAll(x.accept(this).nodes)   );
      return ret;
    }
    for (var child in node.sortedDirectivesAndDeclarations) {
      nodes.addAll(child.accept(this).nodes);
    }
    return ret;
  }
}
