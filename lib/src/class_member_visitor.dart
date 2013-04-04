import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'transformers.dart';
import 'base_visitor.dart';
import 'jsast/js.dart' as js;

class ClassMemberVisitor extends BaseVisitor {
  ClassMemberVisitor(baseOptions) : super(baseOptions);

  List<js.Statement> fields = new List<js.Statement>();
  List<js.Statement> methods = new List<js.Statement>();
  String functionName;

  List<js.Parameter> consParams;
  js.Block consBlock = new js.Block.empty();

  Object visitClassDeclaration(ClassDeclaration node) {
    functionName = node.name.toString();
    node.members.accept(this);

    var ret = new List<js.Statement>();
    // Create the constructor
    ret.add(new js.FunctionDeclaration(
        new js.VariableDeclaration(functionName),
        new js.Fun(consParams, consBlock), "@constructor"
    ));
    ret.addAll(fields);
    ret.addAll(methods);
    return ret;
  }

  Object visitFieldDeclaration(FieldDeclaration node) {
    for (VariableDeclaration decl in node.fields.variables) {
       var name = decl.name.toString();
       fields.add(new js.ExpressionStatement(
          new js.VariableDeclaration.withType(
              "$functionName.prototype.$name", "string")));
    }
  }

  List<js.Parameter> dartParamsToJs(var parameters) {
    var jsParams = new List<js.Parameter>();

    for(FormalParameter param in parameters) {
      String name = param.identifier.name;
      jsParams.add(new js.Parameter(name));
    }
    return jsParams;
  }

  Object visitConstructorDeclaration(ConstructorDeclaration node) {
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
    var funParams = dartParamsToJs(node.parameters.parameters);
    var funBody = node.body.block.accept(this.otherVisitor)[0];
    methods.add(new js.ExpressionStatement(
          new js.Assignment(
           new js.VariableDeclaration.withDoc(
               "$functionName.prototype.$name", "@return {string}"),
           new js.Fun(funParams, funBody))));


  }

}
