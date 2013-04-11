library compilation_member_visitor;

import 'analyzer_experimental/ast.dart';
import 'analyzer_experimental/java_core.dart';

import 'jsast/js.dart' as js;

import 'base_visitor.dart';
import 'lexical_scope.dart';
import 'visit_result.dart';
import 'type_translator.dart';

class CompilationMemberVisitor extends BaseVisitor {
  CompilationMemberVisitor(baseOptions) : super(baseOptions);

  visitFunctionDeclaration(FunctionDeclaration node) {
    js.VariableDeclaration name = new js.VariableDeclaration(node.name.name);

    js.Fun functionBody = node.functionExpression.accept(otherVisitor).node;

    return VisitResult.fromJsNode(new js.FunctionDeclaration(name, functionBody, 'jsdoc TODO'));
  }

  visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    // TODO refactor this into a seperate visitor

    var retNodes = new List();
    for (VariableDeclaration decl in node.variables.variables) {
      var name = decl.name.toString();
      var type = dartTypeIdToJsType(node.variables.type);
      var init = decl.initializer != null ? decl.initializer.accept(this.otherVisitor).node : null;
      var declaration = new js.VariableDeclaration(name);
      var initialization = [new js.VariableInitialization(declaration, init)];
      var declList = new js.VariableDeclarationList.withType(initialization, type);
      retNodes.add(new js.ExpressionStatement(declList));
    }
    return VisitResult.fromJsNodeList(retNodes);
  }

}