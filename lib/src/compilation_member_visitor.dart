library compilation_member_visitor;

import './analyzer_experimental/ast.dart';
import './analyzer_experimental/java_core.dart';

import 'jsast/js.dart' as js;

import 'base_visitor.dart';
import 'lexical_scope.dart';
import 'visit_result.dart';

class CompilationMemberVisitor extends BaseVisitor {
  CompilationMemberVisitor(baseOptions) : super(baseOptions);

  visitFunctionDeclaration(FunctionDeclaration node) {
    js.VariableDeclaration name = new js.VariableDeclaration(node.name.name);

    js.Fun functionBody = node.functionExpression.accept(otherVisitor).node;

    return VisitResult.fromJsNode(new js.FunctionDeclaration(name, functionBody, 'jsdoc TODO'));
  }

}