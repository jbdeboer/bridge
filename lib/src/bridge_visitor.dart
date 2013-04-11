library bridge_visitor;

import 'analyzer_experimental/ast.dart';
import 'analyzer_experimental/java_core.dart';

import 'base_visitor.dart';
import 'class_member_visitor.dart';
import 'compilation_member_visitor.dart';
import 'function_body_visitor.dart';
import 'lexical_scope.dart';
import 'identifier_visitor.dart';
import 'expression_visitor.dart';
import 'unparse_to_closure/block_visitor.dart';

import 'transformers.dart';

import 'jsast/js.dart' as js;


NoOtherVisitor(callee) {
  throw "BridgeVisitor other visitor";
}


Factory(BaseVisitor caller) => new BridgeVisitor(caller);


class BridgeVisitor extends BaseVisitor {
    //LexicalScope scope = new LexicalScope();

    BridgeVisitor(BaseVisitor parentVisitor) : super(new BaseVisitorOptions(NoOtherVisitor, parentVisitor.scope));
    BridgeVisitor.fromScope(LexicalScope scope) : super(new BaseVisitorOptions(NoOtherVisitor, scope));
    BridgeVisitor.root() : super(new BaseVisitorOptions(NoOtherVisitor, new LexicalScope()));

    options() => new BaseVisitorOptions(Factory, scope);

    visitAdjacentStrings(AdjacentStrings node) => visitExpression(node);

//  R visitAnnotation(Annotation node);
//  R visitArgumentDefinitionTest(ArgumentDefinitionTest node);
//  R visitArgumentList(ArgumentList node);
//  R visitAsExpression(AsExpression node);
//    visitAssertStatement(AssertStatement assertStatement) => visitStatement(node);

    visitAssignmentExpression(AssignmentExpression node) => visitExpression(node);


  visitBinaryExpression(BinaryExpression node) => visitExpression(node);

  visitExpression(Expression node) {
    var visitor = new ExpressionVisitor(options());

    return node.accept(visitor);
  }


  visitBlock(node) =>
    node.accept(new BlockVisitor.root(options()));

  visitFunctionBody(node) =>
    node.accept(new FunctionBodyVisitor(options()));


  visitBlockFunctionBody(BlockFunctionBody node) => visitFunctionBody(node);
  /*
  R visitBooleanLiteral(BooleanLiteral node);
  R visitBreakStatement(BreakStatement node);
*/
  visitCascadeExpression(CascadeExpression node) => visitExpression(node);
/*
  R visitCatchClause(CatchClause node); */

  visitClassDeclaration(ClassDeclaration node) =>
    node.accept(new ClassMemberVisitor(options()));

/*
  R visitClassTypeAlias(ClassTypeAlias node); */

/*
  R visitCommentReference(CommentReference node); */


  visitConditionalExpression(ConditionalExpression node) => visitExpression(node);

/*
  R visitConstructorDeclaration(ConstructorDeclaration node);
  R visitConstructorFieldInitializer(ConstructorFieldInitializer node);
  R visitConstructorName(ConstructorName node);
  R visitContinueStatement(ContinueStatement node);
  R visitDeclaredIdentifier(DeclaredIdentifier node);
  R visitDefaultFormalParameter(DefaultFormalParameter node);
  R visitDoStatement(DoStatement node); */

  visitDoubleLiteral(DoubleLiteral node) => visitExpression(node);


  visitEmptyFunctionBody(EmptyFunctionBody node) => visitFunctionBody(node);

  /*R visitEmptyStatement(EmptyStatement node);
  R visitExportDirective(ExportDirective node);
  */
  visitExpressionFunctionBody(ExpressionFunctionBody node) => visitFunctionBody(node);

  visitExpressionStatement(ExpressionStatement node) => visitExpression(node);
  /*
  R visitExtendsClause(ExtendsClause node);
  R visitFieldDeclaration(FieldDeclaration node);
  R visitFieldFormalParameter(FieldFormalParameter node);
  R visitForEachStatement(ForEachStatement node);
  R visitFormalParameterList(FormalParameterList node);
  R visitForStatement(ForStatement node); */


  visitCompilationUnitMember(node) =>
      node.accept(new CompilationMemberVisitor(options()));

  visitFunctionDeclaration(FunctionDeclaration node) => visitCompilationUnitMember(node);
  /*
  R visitFunctionDeclarationStatement(FunctionDeclarationStatement node);
  */
  visitFunctionExpression(FunctionExpression node) => visitExpression(node);
  /*
  R visitFunctionExpressionInvocation(FunctionExpressionInvocation node);
  R visitFunctionTypeAlias(FunctionTypeAlias functionTypeAlias);
  R visitFunctionTypedFormalParameter(FunctionTypedFormalParameter node);
  R visitHideCombinator(HideCombinator node);
  R visitIfStatement(IfStatement node);
  R visitImplementsClause(ImplementsClause node); */

  visitImportDirective(ImportDirective node) => [];

  visitIndexExpression(IndexExpression node) => visitExpression(node);

  visitInstanceCreationExpression(InstanceCreationExpression node) => visitExpression(node);

  visitIntegerLiteral(IntegerLiteral node) => visitExpression(node);

  visitInterpolationExpression(InterpolationExpression node) => visitExpression(node);
  // visitInterpolationString(InterpolationString node);
  visitIsExpression(IsExpression node) => visitExpression(node);
/*  R visitLabel(Label node);
  R visitLabeledStatement(LabeledStatement node);
  R visitLibraryDirective(LibraryDirective node);
  R visitLibraryIdentifier(LibraryIdentifier node);
*/
  visitListLiteral(ListLiteral node) => visitExpression(node);
  visitMapLiteral(MapLiteral node) => visitExpression(node);
//  R visitMapLiteralEntry(MapLiteralEntry node);
// visitMethodDeclaration(MethodDeclaration node); */

  visitMethodInvocation(MethodInvocation node) => visitExpression(node);

  visitNamedExpression(NamedExpression node) => visitExpression(node);
  visitNullLiteral(NullLiteral node) => visitExpression(node);
  visitParenthesizedExpression(ParenthesizedExpression node) => visitExpression(node);
/*  R visitPartDirective(PartDirective node);
  R visitPartOfDirective(PartOfDirective node); */

  visitPostfixExpression(PostfixExpression node) => visitExpression(node);

  visitPrefixedIdentifier(PrefixedIdentifier node) => visitIdentifier(node);

  visitPrefixExpression(PrefixExpression node) => visitExpression(node);
  visitPropertyAccess(PropertyAccess node) => visitExpression(node);
  /*
  R visitRedirectingConstructorInvocation(RedirectingConstructorInvocation node);
  R visitReturnStatement(ReturnStatement node);
  R visitScriptTag(ScriptTag node);
  R visitShowCombinator(ShowCombinator node);
  R visitSimpleFormalParameter(SimpleFormalParameter node); */

  visitSimpleIdentifier(SimpleIdentifier node) => visitIdentifier(node);

  visitIdentifier(node) =>
      node.accept(new IdentifierVisitor(options()));

  Object visitSimpleStringLiteral(SimpleStringLiteral node) => visitExpression(node);

  //R visitStringInterpolation(StringInterpolation node);
  visitSuperConstructorInvocation(SuperConstructorInvocation node);
  visitSuperExpression(SuperExpression node) => visitExpression(node);
 // R visitSwitchCase(SwitchCase node);
 // R visitSwitchDefault(SwitchDefault node);
 // R visitSwitchStatement(SwitchStatement node);
  visitThisExpression(ThisExpression node) => visitExpression(node);
  visitThrowExpression(ThrowExpression node) => visitExpression(node);

//  visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) =>

/*
  R visitTryStatement(TryStatement node);
  R visitTypeArgumentList(TypeArgumentList node); */

/*Object visitTypeName(TypeName node) {
    node.visitChildren(this);
  }*/

/*
  R visitTypeParameter(TypeParameter node);
  R visitTypeParameterList(TypeParameterList node); */

 //   Object visitVariableDeclaration(VariableDeclaration node) {


//node.visitChildren(this);
  //  }




//    Object visitVariableDeclarationList(VariableDeclarationList node) {
//
//      for (VariableDeclaration decl in node.variables) {
//        this._writer.print(variableDeclarationToString(decl, node.type, "var "));
//      }
//
////node.visitChildren(this);
//
//    }

/*
  R visitVariableDeclarationStatement(VariableDeclarationStatement node);
  R visitWhileStatement(WhileStatement node);
  R visitWithClause(WithClause node);
*/
  //}
}
