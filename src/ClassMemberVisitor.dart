import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'transformers.dart';

class ClassMemberVisitor implements ASTVisitor<Object> {
  String namespace;

  ClassMemberVisitor(this.namespace);

  List<String> fields = new List<String>();

  Object visitFieldDeclaration(FieldDeclaration node) {
    //for (VariableDeclarationList varList in node.fields) {
      for (VariableDeclaration decl in node.fields.variables) {
        fields.add(variableDeclarationToString(decl, node.fields.type, namespace));
      }
   // }
  }
}
