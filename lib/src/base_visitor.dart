import 'package:analyzer_experimental/src/generated/ast.dart';
import 'jsast/js.dart' as js;


class BaseVisitor implements ASTVisitor<List<js.Node>> {
  List<js.Node> visitCompilationUnit(CompilationUnit node) {
    node.visitChildren(this);
  }
}
