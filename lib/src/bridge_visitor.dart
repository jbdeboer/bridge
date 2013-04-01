import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'class_member_visitor.dart';
import 'transformers.dart';
import 'jsast/js.dart' as js;

class BridgeVisitor implements ASTVisitor<Object> {
  PrintWriter _writer;

  BridgeVisitor(PrintWriter writer) {
    this._writer = writer;
  }

 /**
  R visitAdjacentStrings(AdjacentStrings node);
  R visitAnnotation(Annotation node);
  R visitArgumentDefinitionTest(ArgumentDefinitionTest node);
  R visitArgumentList(ArgumentList node);
  R visitAsExpression(AsExpression node);
  R visitAssertStatement(AssertStatement assertStatement);
  R visitAssignmentExpression(AssignmentExpression node);
  R visitBinaryExpression(BinaryExpression node); */

  List<js.Node> visitBlock(Block node) {
    return [new js.Comment('VISIT BLOCK')];
  }

  /*
  R visitBlock(Block node);
  R visitBlockFunctionBody(BlockFunctionBody node);
  R visitBooleanLiteral(BooleanLiteral node);
  R visitBreakStatement(BreakStatement node);
  R visitCascadeExpression(CascadeExpression node);
  R visitCatchClause(CatchClause node); */

  Object visitClassDeclaration(ClassDeclaration node) {
    var cmv = new ClassMemberVisitor(this);
    node.accept(cmv);
    for (var s in cmv.statements) {
      this._writer.print(js.prettyPrint(s).getText());
    }
  }
    /*
    this._writer.print(cmv.statements.getText())
    String functionName = node.name.toString();


    var cmv = new ClassMemberVisitor("$functionName.prototype.");
    for (ClassMember member in node.members) {
      member.accept(cmv);
    }
    this._writer.print("""/\**
 * @constructor
 * /
function $functionName(${cmv.consParams}) ${cmv.constructor}\n\n""");

    for (String s in cmv.fields) {
      this._writer.print(s);
    }
  } */

  /*
  R visitClassTypeAlias(ClassTypeAlias node); */

  Object visitComment(Comment node) {
    this._writer.print("comment");
  }

  /*
  R visitCommentReference(CommentReference node); */

  Object visitCompilationUnit(CompilationUnit node) {
    node.visitChildren(this);
  }

  /*
  R visitConditionalExpression(ConditionalExpression node);
  R visitConstructorDeclaration(ConstructorDeclaration node);
  R visitConstructorFieldInitializer(ConstructorFieldInitializer node);
  R visitConstructorName(ConstructorName node);
  R visitContinueStatement(ContinueStatement node);
  R visitDeclaredIdentifier(DeclaredIdentifier node);
  R visitDefaultFormalParameter(DefaultFormalParameter node);
  R visitDoStatement(DoStatement node);
  R visitDoubleLiteral(DoubleLiteral node);
  R visitEmptyFunctionBody(EmptyFunctionBody node);
  R visitEmptyStatement(EmptyStatement node);
  R visitExportDirective(ExportDirective node);
  R visitExpressionFunctionBody(ExpressionFunctionBody node);
  R visitExpressionStatement(ExpressionStatement node);
  R visitExtendsClause(ExtendsClause node);
  R visitFieldDeclaration(FieldDeclaration node);
  R visitFieldFormalParameter(FieldFormalParameter node);
  R visitForEachStatement(ForEachStatement node);
  R visitFormalParameterList(FormalParameterList node);
  R visitForStatement(ForStatement node);
  R visitFunctionDeclaration(FunctionDeclaration node);
  R visitFunctionDeclarationStatement(FunctionDeclarationStatement node);
  R visitFunctionExpression(FunctionExpression node);
  R visitFunctionExpressionInvocation(FunctionExpressionInvocation node);
  R visitFunctionTypeAlias(FunctionTypeAlias functionTypeAlias);
  R visitFunctionTypedFormalParameter(FunctionTypedFormalParameter node);
  R visitHideCombinator(HideCombinator node);
  R visitIfStatement(IfStatement node);
  R visitImplementsClause(ImplementsClause node);
  R visitImportDirective(ImportDirective node);
  R visitIndexExpression(IndexExpression node);
  R visitInstanceCreationExpression(InstanceCreationExpression node); */

  /*Object visitIntegerLiteral(IntegerLiteral node) {
    node.visitChildren(this);
  }*/

  /*
  R visitInterpolationExpression(InterpolationExpression node);
  R visitInterpolationString(InterpolationString node);
  R visitIsExpression(IsExpression node);
  R visitLabel(Label node);
  R visitLabeledStatement(LabeledStatement node);
  R visitLibraryDirective(LibraryDirective node);
  R visitLibraryIdentifier(LibraryIdentifier node);
  R visitListLiteral(ListLiteral node);
  R visitMapLiteral(MapLiteral node);
  R visitMapLiteralEntry(MapLiteralEntry node);
  R visitMethodDeclaration(MethodDeclaration node);
  R visitMethodInvocation(MethodInvocation node);
  R visitNamedExpression(NamedExpression node);
  R visitNullLiteral(NullLiteral node);
  R visitParenthesizedExpression(ParenthesizedExpression node);
  R visitPartDirective(PartDirective node);
  R visitPartOfDirective(PartOfDirective node);
  R visitPostfixExpression(PostfixExpression node);
  R visitPrefixedIdentifier(PrefixedIdentifier node);
  R visitPrefixExpression(PrefixExpression node);
  R visitPropertyAccess(PropertyAccess node);
  R visitRedirectingConstructorInvocation(RedirectingConstructorInvocation node);
  R visitReturnStatement(ReturnStatement node);
  R visitScriptTag(ScriptTag node);
  R visitShowCombinator(ShowCombinator node);
  R visitSimpleFormalParameter(SimpleFormalParameter node); */

  /*Object visitSimpleIdentifier(SimpleIdentifier node) {
      node.visitChildren(this);
  }

  Object visitSimpleStringLiteral(SimpleStringLiteral node) {
    node.visitChildren(this);
  }*/
  /*
  R visitStringInterpolation(StringInterpolation node);
  R visitSuperConstructorInvocation(SuperConstructorInvocation node);
  R visitSuperExpression(SuperExpression node);
  R visitSwitchCase(SwitchCase node);
  R visitSwitchDefault(SwitchDefault node);
  R visitSwitchStatement(SwitchStatement node);
  R visitThisExpression(ThisExpression node);
  R visitThrowExpression(ThrowExpression node); */

  Object visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    node.visitChildren(this);
  }

  /*
  R visitTryStatement(TryStatement node);
  R visitTypeArgumentList(TypeArgumentList node); */

  /*Object visitTypeName(TypeName node) {
    node.visitChildren(this);
  }*/

  /*
  R visitTypeParameter(TypeParameter node);
  R visitTypeParameterList(TypeParameterList node); */

  Object visitVariableDeclaration(VariableDeclaration node) {


    //node.visitChildren(this);
  }




  Object visitVariableDeclarationList(VariableDeclarationList node) {

    for (VariableDeclaration decl in node.variables) {
      this._writer.print(variableDeclarationToString(decl, node.type, "var "));
    }

    //node.visitChildren(this);

  }

  /*
  R visitVariableDeclarationStatement(VariableDeclarationStatement node);
  R visitWhileStatement(WhileStatement node);
  R visitWithClause(WithClause node);
*/
}
