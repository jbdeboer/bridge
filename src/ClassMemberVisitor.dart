import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'transformers.dart';

class ClassMemberVisitor implements ASTVisitor<Object> {
  String namespace;

  ClassMemberVisitor(this.namespace);

  List<String> fields = new List<String>();
  String constructor = "{ }";
  String consParams = "";

  Object visitFieldDeclaration(FieldDeclaration node) {
    for (VariableDeclaration decl in node.fields.variables) {
      fields.add(variableDeclarationToString(decl, node.fields.type, namespace));
    }
  }

  Object visitConstructorDeclaration(ConstructorDeclaration node) {
     constructor = "{\n";
     List<String> params = new List<String>();
     for(FormalParameter param in node.parameters.parameters) {
       String name = param.identifier.name;
       constructor = "$constructor  this.$name = $name;\n";
       params.add(name);
     }
     constructor = "$constructor}";
     consParams = params.join(', ');
  }

}
