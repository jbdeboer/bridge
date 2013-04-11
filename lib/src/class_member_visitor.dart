library class_member_visitor;

import 'analyzer_experimental/ast.dart';
import 'analyzer_experimental/java_core.dart';

import 'jsast/js.dart' as js;

import 'base_visitor.dart';
import 'lexical_scope.dart';
import 'transformers.dart';
import 'visit_result.dart';
import 'static_type_analyzer.dart';
import 'type_translator.dart';


class ClassMemberNameCollectorVisitor extends ASTVisitor<Object> {
  LexicalScope scope;

  ClassMemberNameCollectorVisitor(this.scope);

  visitFieldDeclaration(FieldDeclaration node) {
    for (VariableDeclaration decl in node.fields.variables) {
        var name = decl.name.toString();
        scope.addName(name);
    }
  }

  visitMethodDeclaration(MethodDeclaration node) {
    String name = node.name.name;
    scope.addName(name);


  }

  visitConstructorDeclaration(ConstructorDeclaration node) {}
}

class ClassMemberVisitor extends BaseVisitor {
  ClassMemberVisitor(baseOptions) : super(baseOptions) { assert(scope != null); }

  List<js.Statement> fields = new List<js.Statement>();
  List<js.Statement> methods = new List<js.Statement>();
  String functionName;

  List<js.Parameter> consParams;
  js.Block consBlock = new js.Block.empty();

  VisitResult visitClassDeclaration(ClassDeclaration node) {
    assert(scope != null);
    scope.currentScope = LexicalScope.CLASS;

    scope = new LexicalScope.clone(scope);

    functionName = node.name.toString();
    node.members.accept(new ClassMemberNameCollectorVisitor(scope));
    node.members.accept(this);

    var ret = new List<js.Statement>();
    // Create the constructor
    ret.add(new js.FunctionDeclaration(
        new js.VariableDeclaration(functionName),
        new js.Fun(consParams, consBlock), "@constructor"
    ));
    ret.addAll(fields);
    ret.addAll(methods);
    return VisitResult.fromJsNodeList(ret);
  }

  Object visitFieldDeclaration(FieldDeclaration node) {
    for (VariableDeclaration decl in node.fields.variables) {
       var name = decl.name.toString();
       var type = dartTypeStringToJsType(node.fields.type.name);
       fields.add(new js.ExpressionStatement(
          new js.VariableDeclaration.withType(
              "$functionName.prototype.$name", type)));
    }
  }

  List<js.Parameter> dartParamsToJs(var parameters) {
    return parameters.map((param) => new js.Parameter(param.identifier.name)).toList();
  }

  Object visitConstructorDeclaration(ConstructorDeclaration node) {
     if (consParams != null) { throw "two constructors"; }
     consParams = dartParamsToJs(node.parameters.parameters);
     var consStatements = new List<js.Statement>();

     for(FormalParameter param in node.parameters.parameters) {
       String name = param.identifier.name;

      consStatements.add(new js.ExpressionStatement(
          new js.Assignment(
           new js.VariableDeclaration("this.$name"),
           new js.VariableUse(name))));
     }
     consBlock = new js.Block(consStatements);
  }

  Object visitMethodDeclaration(MethodDeclaration node) {
    String name = node.name.name;
    String returnType = node.returnType != null ? dartTypeStringToJsType(node.returnType.name) : "?";

    var funParams = dartParamsToJs(node.parameters.parameters);

    var funBody = node.body.accept(this.otherVisitor).node;
    methods.add(new js.ExpressionStatement(
          new js.Assignment(
           new js.VariableDeclaration.withDoc(
               "$functionName.prototype.$name", "@return {$returnType}"),
           new js.Fun(funParams, funBody))));


  }

}
