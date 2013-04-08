// This code was auto-generated, is not intended to be edited, and is subject to
// significant change. Please see the README file for more information.

library engine.ast_test;

import 'dart:collection';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';
import 'package:analyzer_experimental/src/generated/source.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/utilities_dart.dart';
import 'package:analyzer_experimental/src/generated/element.dart' show ClassElement;
import 'package:unittest/unittest.dart' as _ut;


import 'token_factory.dart';


/**
 * The class {@code ASTFactory} defines utility methods that can be used to create AST nodes. The
 * nodes that are created are complete in the sense that all of the tokens that would have been
 * associated with the nodes by a parser are also created, but the token stream is not constructed.
 * None of the nodes are resolved.
 * <p>
 * The general pattern is for the name of the factory method to be the same as the name of the class
 * of AST node being created. There are two notable exceptions. The first is for methods creating
 * nodes that are part of a cascade expression. These methods are all prefixed with 'cascaded'. The
 * second is places where a shorter name seemed unambiguous and easier to read, such as using
 * 'identifier' rather than 'prefixedIdentifier', or 'integer' rather than 'integerLiteral'.
 */
class ASTFactory {
  static AdjacentStrings adjacentStrings(List<StringLiteral> strings) => new AdjacentStrings.full(list(strings));
  static Annotation annotation(Identifier name) => new Annotation.full(TokenFactory.token3(TokenType.AT), name, null, null, null);
  static Annotation annotation2(Identifier name, SimpleIdentifier constructorName, ArgumentList arguments) => new Annotation.full(TokenFactory.token3(TokenType.AT), name, TokenFactory.token3(TokenType.PERIOD), constructorName, arguments);
  static ArgumentDefinitionTest argumentDefinitionTest(String identifier) => new ArgumentDefinitionTest.full(TokenFactory.token3(TokenType.QUESTION), identifier2(identifier));
  static ArgumentList argumentList(List<Expression> arguments) => new ArgumentList.full(TokenFactory.token3(TokenType.OPEN_PAREN), list(arguments), TokenFactory.token3(TokenType.CLOSE_PAREN));
  static AsExpression asExpression(Expression expression, TypeName type) => new AsExpression.full(expression, TokenFactory.token(Keyword.AS), type);
  static AssertStatement assertStatement(Expression condition) => new AssertStatement.full(TokenFactory.token(Keyword.ASSERT), TokenFactory.token3(TokenType.OPEN_PAREN), condition, TokenFactory.token3(TokenType.CLOSE_PAREN), TokenFactory.token3(TokenType.SEMICOLON));
  static AssignmentExpression assignmentExpression(Expression leftHandSide, TokenType operator, Expression rightHandSide) => new AssignmentExpression.full(leftHandSide, TokenFactory.token3(operator), rightHandSide);
  static BinaryExpression binaryExpression(Expression leftOperand, TokenType operator, Expression rightOperand) => new BinaryExpression.full(leftOperand, TokenFactory.token3(operator), rightOperand);
  static Block block(List<Statement> statements) => new Block.full(TokenFactory.token3(TokenType.OPEN_CURLY_BRACKET), list(statements), TokenFactory.token3(TokenType.CLOSE_CURLY_BRACKET));
  static BlockFunctionBody blockFunctionBody(List<Statement> statements) => new BlockFunctionBody.full(block(statements));
  static BooleanLiteral booleanLiteral(bool value) => new BooleanLiteral.full(value ? TokenFactory.token(Keyword.TRUE) : TokenFactory.token(Keyword.FALSE), value);
  static BreakStatement breakStatement() => new BreakStatement.full(TokenFactory.token(Keyword.BREAK), null, TokenFactory.token3(TokenType.SEMICOLON));
  static BreakStatement breakStatement2(String label) => new BreakStatement.full(TokenFactory.token(Keyword.BREAK), identifier2(label), TokenFactory.token3(TokenType.SEMICOLON));
  static IndexExpression cascadedIndexExpression(Expression index) => new IndexExpression.forCascade_full(TokenFactory.token3(TokenType.PERIOD_PERIOD), TokenFactory.token3(TokenType.OPEN_SQUARE_BRACKET), index, TokenFactory.token3(TokenType.CLOSE_SQUARE_BRACKET));
  static MethodInvocation cascadedMethodInvocation(String methodName, List<Expression> arguments) => new MethodInvocation.full(null, TokenFactory.token3(TokenType.PERIOD_PERIOD), identifier2(methodName), argumentList(arguments));
  static PropertyAccess cascadedPropertyAccess(String propertyName) => new PropertyAccess.full(null, TokenFactory.token3(TokenType.PERIOD_PERIOD), identifier2(propertyName));
  static CascadeExpression cascadeExpression(Expression target, List<Expression> cascadeSections) => new CascadeExpression.full(target, list(cascadeSections));
  static CatchClause catchClause(String exceptionParameter, List<Statement> statements) => catchClause5(null, exceptionParameter, null, statements);
  static CatchClause catchClause2(String exceptionParameter, String stackTraceParameter, List<Statement> statements) => catchClause5(null, exceptionParameter, stackTraceParameter, statements);
  static CatchClause catchClause3(TypeName exceptionType, List<Statement> statements) => catchClause5(exceptionType, null, null, statements);
  static CatchClause catchClause4(TypeName exceptionType, String exceptionParameter, List<Statement> statements) => catchClause5(exceptionType, exceptionParameter, null, statements);
  static CatchClause catchClause5(TypeName exceptionType, String exceptionParameter, String stackTraceParameter, List<Statement> statements) => new CatchClause.full(exceptionType == null ? null : TokenFactory.token4(TokenType.IDENTIFIER, "on"), exceptionType, exceptionParameter == null ? null : TokenFactory.token(Keyword.CATCH), exceptionParameter == null ? null : TokenFactory.token3(TokenType.OPEN_PAREN), identifier2(exceptionParameter), stackTraceParameter == null ? null : TokenFactory.token3(TokenType.COMMA), stackTraceParameter == null ? null : identifier2(stackTraceParameter), exceptionParameter == null ? null : TokenFactory.token3(TokenType.CLOSE_PAREN), block(statements));
  static ClassDeclaration classDeclaration(Keyword abstractKeyword, String name, TypeParameterList typeParameters, ExtendsClause extendsClause, WithClause withClause, ImplementsClause implementsClause, List<ClassMember> members) => new ClassDeclaration.full(null, null, abstractKeyword == null ? null : TokenFactory.token(abstractKeyword), TokenFactory.token(Keyword.CLASS), identifier2(name), typeParameters, extendsClause, withClause, implementsClause, TokenFactory.token3(TokenType.OPEN_CURLY_BRACKET), list(members), TokenFactory.token3(TokenType.CLOSE_CURLY_BRACKET));
  static ClassTypeAlias classTypeAlias(String name, TypeParameterList typeParameters, Keyword abstractKeyword, TypeName superclass, WithClause withClause, ImplementsClause implementsClause) => new ClassTypeAlias.full(null, null, TokenFactory.token(Keyword.TYPEDEF), identifier2(name), typeParameters, TokenFactory.token3(TokenType.EQ), abstractKeyword == null ? null : TokenFactory.token(abstractKeyword), superclass, withClause, implementsClause, TokenFactory.token3(TokenType.SEMICOLON));
  static CompilationUnit compilationUnit() => compilationUnit8(null, null, null);
  static CompilationUnit compilationUnit2(List<CompilationUnitMember> declarations) => compilationUnit8(null, null, list(declarations));
  static CompilationUnit compilationUnit3(List<Directive> directives) => compilationUnit8(null, list(directives), null);
  static CompilationUnit compilationUnit4(List<Directive> directives, List<CompilationUnitMember> declarations) => compilationUnit8(null, directives, declarations);
  static CompilationUnit compilationUnit5(String scriptTag) => compilationUnit8(scriptTag, null, null);
  static CompilationUnit compilationUnit6(String scriptTag, List<CompilationUnitMember> declarations) => compilationUnit8(scriptTag, null, list(declarations));
  static CompilationUnit compilationUnit7(String scriptTag, List<Directive> directives) => compilationUnit8(scriptTag, list(directives), null);
  static CompilationUnit compilationUnit8(String scriptTag4, List<Directive> directives, List<CompilationUnitMember> declarations) => new CompilationUnit.full(TokenFactory.token3(TokenType.EOF), scriptTag4 == null ? null : scriptTag(scriptTag4), directives == null ? new List<Directive>() : directives, declarations == null ? new List<CompilationUnitMember>() : declarations, TokenFactory.token3(TokenType.EOF));
  static ConditionalExpression conditionalExpression(Expression condition, Expression thenExpression, Expression elseExpression) => new ConditionalExpression.full(condition, TokenFactory.token3(TokenType.QUESTION), thenExpression, TokenFactory.token3(TokenType.COLON), elseExpression);
  static ConstructorDeclaration constructorDeclaration(Identifier returnType, String name, FormalParameterList parameters, List<ConstructorInitializer> initializers) => new ConstructorDeclaration.full(null, null, TokenFactory.token(Keyword.EXTERNAL), null, null, returnType, name == null ? null : TokenFactory.token3(TokenType.PERIOD), name == null ? null : identifier2(name), parameters, initializers == null || initializers.isEmpty ? null : TokenFactory.token3(TokenType.PERIOD), initializers == null ? new List<ConstructorInitializer>() : initializers, null, emptyFunctionBody());
  static ConstructorDeclaration constructorDeclaration2(Keyword constKeyword, Keyword factoryKeyword, Identifier returnType, String name, FormalParameterList parameters, List<ConstructorInitializer> initializers, FunctionBody body) => new ConstructorDeclaration.full(null, null, null, constKeyword == null ? null : TokenFactory.token(constKeyword), factoryKeyword == null ? null : TokenFactory.token(factoryKeyword), returnType, name == null ? null : TokenFactory.token3(TokenType.PERIOD), name == null ? null : identifier2(name), parameters, initializers == null || initializers.isEmpty ? null : TokenFactory.token3(TokenType.PERIOD), initializers == null ? new List<ConstructorInitializer>() : initializers, null, body);
  static ConstructorFieldInitializer constructorFieldInitializer(bool prefixedWithThis, String fieldName, Expression expression) => new ConstructorFieldInitializer.full(prefixedWithThis ? TokenFactory.token(Keyword.THIS) : null, prefixedWithThis ? TokenFactory.token3(TokenType.PERIOD) : null, identifier2(fieldName), TokenFactory.token3(TokenType.EQ), expression);
  static ConstructorName constructorName(TypeName type, String name) => new ConstructorName.full(type, name == null ? null : TokenFactory.token3(TokenType.PERIOD), name == null ? null : identifier2(name));
  static ContinueStatement continueStatement() => new ContinueStatement.full(TokenFactory.token(Keyword.CONTINUE), null, TokenFactory.token3(TokenType.SEMICOLON));
  static ContinueStatement continueStatement2(String label) => new ContinueStatement.full(TokenFactory.token(Keyword.CONTINUE), identifier2(label), TokenFactory.token3(TokenType.SEMICOLON));
  static DeclaredIdentifier declaredIdentifier(Keyword keyword, String identifier) => declaredIdentifier2(keyword, null, identifier);
  static DeclaredIdentifier declaredIdentifier2(Keyword keyword, TypeName type, String identifier) => new DeclaredIdentifier.full(null, null, keyword == null ? null : TokenFactory.token(keyword), type, identifier2(identifier));
  static DeclaredIdentifier declaredIdentifier3(String identifier) => declaredIdentifier2(null, null, identifier);
  static DeclaredIdentifier declaredIdentifier4(TypeName type, String identifier) => declaredIdentifier2(null, type, identifier);
  static DoStatement doStatement(Statement body, Expression condition) => new DoStatement.full(TokenFactory.token(Keyword.DO), body, TokenFactory.token(Keyword.WHILE), TokenFactory.token3(TokenType.OPEN_PAREN), condition, TokenFactory.token3(TokenType.CLOSE_PAREN), TokenFactory.token3(TokenType.SEMICOLON));
  static DoubleLiteral doubleLiteral(double value) => new DoubleLiteral.full(TokenFactory.token2(value.toString()), value);
  static EmptyFunctionBody emptyFunctionBody() => new EmptyFunctionBody.full(TokenFactory.token3(TokenType.SEMICOLON));
  static EmptyStatement emptyStatement() => new EmptyStatement.full(TokenFactory.token3(TokenType.SEMICOLON));
  static ExportDirective exportDirective(List<Annotation> metadata, String uri, List<Combinator> combinators) => new ExportDirective.full(null, metadata, TokenFactory.token(Keyword.EXPORT), string2(uri), list(combinators), TokenFactory.token3(TokenType.SEMICOLON));
  static ExportDirective exportDirective2(String uri, List<Combinator> combinators) => exportDirective(new List<Annotation>(), uri, combinators);
  static ExpressionFunctionBody expressionFunctionBody(Expression expression) => new ExpressionFunctionBody.full(TokenFactory.token3(TokenType.FUNCTION), expression, TokenFactory.token3(TokenType.SEMICOLON));
  static ExpressionStatement expressionStatement(Expression expression) => new ExpressionStatement.full(expression, TokenFactory.token3(TokenType.SEMICOLON));
  static ExtendsClause extendsClause(TypeName type) => new ExtendsClause.full(TokenFactory.token(Keyword.EXTENDS), type);
  static FieldDeclaration fieldDeclaration(bool isStatic, Keyword keyword, TypeName type, List<VariableDeclaration> variables) => new FieldDeclaration.full(null, null, isStatic ? TokenFactory.token(Keyword.STATIC) : null, variableDeclarationList(keyword, type, variables), TokenFactory.token3(TokenType.SEMICOLON));
  static FieldDeclaration fieldDeclaration2(bool isStatic, Keyword keyword, List<VariableDeclaration> variables) => fieldDeclaration(isStatic, keyword, null, variables);
  static FieldFormalParameter fieldFormalParameter(Keyword keyword, TypeName type, String identifier) => new FieldFormalParameter.full(null, null, keyword == null ? null : TokenFactory.token(keyword), type, TokenFactory.token(Keyword.THIS), TokenFactory.token3(TokenType.PERIOD), identifier2(identifier));
  static ForEachStatement forEachStatement(DeclaredIdentifier loopVariable, Expression iterator, Statement body) => new ForEachStatement.full(TokenFactory.token(Keyword.FOR), TokenFactory.token3(TokenType.OPEN_PAREN), loopVariable, TokenFactory.token(Keyword.IN), iterator, TokenFactory.token3(TokenType.CLOSE_PAREN), body);
  static FormalParameterList formalParameterList(List<FormalParameter> parameters) => new FormalParameterList.full(TokenFactory.token3(TokenType.OPEN_PAREN), list(parameters), null, null, TokenFactory.token3(TokenType.CLOSE_PAREN));
  static ForStatement forStatement(Expression initialization, Expression condition, List<Expression> updaters, Statement body) => new ForStatement.full(TokenFactory.token(Keyword.FOR), TokenFactory.token3(TokenType.OPEN_PAREN), null, initialization, TokenFactory.token3(TokenType.SEMICOLON), condition, TokenFactory.token3(TokenType.SEMICOLON), updaters, TokenFactory.token3(TokenType.CLOSE_PAREN), body);
  static ForStatement forStatement2(VariableDeclarationList variableList, Expression condition, List<Expression> updaters, Statement body) => new ForStatement.full(TokenFactory.token(Keyword.FOR), TokenFactory.token3(TokenType.OPEN_PAREN), variableList, null, TokenFactory.token3(TokenType.SEMICOLON), condition, TokenFactory.token3(TokenType.SEMICOLON), updaters, TokenFactory.token3(TokenType.CLOSE_PAREN), body);
  static FunctionDeclaration functionDeclaration(TypeName type, Keyword keyword, String name, FunctionExpression functionExpression) => new FunctionDeclaration.full(null, null, null, type, keyword == null ? null : TokenFactory.token(keyword), identifier2(name), functionExpression);
  static FunctionDeclarationStatement functionDeclarationStatement(TypeName type, Keyword keyword, String name, FunctionExpression functionExpression) => new FunctionDeclarationStatement.full(functionDeclaration(type, keyword, name, functionExpression));
  static FunctionExpression functionExpression() => new FunctionExpression.full(formalParameterList([]), blockFunctionBody([]));
  static FunctionExpression functionExpression2(FormalParameterList parameters, FunctionBody body) => new FunctionExpression.full(parameters, body);
  static FunctionExpressionInvocation functionExpressionInvocation(Expression function, List<Expression> arguments) => new FunctionExpressionInvocation.full(function, argumentList(arguments));
  static FunctionTypedFormalParameter functionTypedFormalParameter(TypeName returnType, String identifier, List<FormalParameter> parameters) => new FunctionTypedFormalParameter.full(null, null, returnType, identifier2(identifier), formalParameterList(parameters));
  static HideCombinator hideCombinator(List<SimpleIdentifier> identifiers) => new HideCombinator.full(TokenFactory.token2("hide"), list(identifiers));
  static HideCombinator hideCombinator2(List<String> identifiers) {
    List<SimpleIdentifier> identifierList = new List<SimpleIdentifier>();
    for (String identifier in identifiers) {
      identifierList.add(identifier2(identifier));
    }
    return new HideCombinator.full(TokenFactory.token2("hide"), identifierList);
  }
  static PrefixedIdentifier identifier(SimpleIdentifier prefix, SimpleIdentifier identifier10) => new PrefixedIdentifier.full(prefix, TokenFactory.token3(TokenType.PERIOD), identifier10);
  static SimpleIdentifier identifier2(String lexeme) => new SimpleIdentifier.full(TokenFactory.token4(TokenType.IDENTIFIER, lexeme));
  static PrefixedIdentifier identifier3(String prefix, SimpleIdentifier identifier) => new PrefixedIdentifier.full(identifier2(prefix), TokenFactory.token3(TokenType.PERIOD), identifier);
  static PrefixedIdentifier identifier4(String prefix, String identifier) => new PrefixedIdentifier.full(identifier2(prefix), TokenFactory.token3(TokenType.PERIOD), identifier2(identifier));
  static IfStatement ifStatement(Expression condition, Statement thenStatement) => ifStatement2(condition, thenStatement, null);
  static IfStatement ifStatement2(Expression condition, Statement thenStatement, Statement elseStatement) => new IfStatement.full(TokenFactory.token(Keyword.IF), TokenFactory.token3(TokenType.OPEN_PAREN), condition, TokenFactory.token3(TokenType.CLOSE_PAREN), thenStatement, elseStatement == null ? null : TokenFactory.token(Keyword.ELSE), elseStatement);
  static ImplementsClause implementsClause(List<TypeName> types) => new ImplementsClause.full(TokenFactory.token(Keyword.IMPLEMENTS), list(types));
  static ImportDirective importDirective(List<Annotation> metadata, String uri, String prefix, List<Combinator> combinators) => new ImportDirective.full(null, metadata, TokenFactory.token(Keyword.IMPORT), string2(uri), prefix == null ? null : TokenFactory.token(Keyword.AS), prefix == null ? null : identifier2(prefix), list(combinators), TokenFactory.token3(TokenType.SEMICOLON));
  static ImportDirective importDirective2(String uri, String prefix, List<Combinator> combinators) => importDirective(new List<Annotation>(), uri, prefix, combinators);
  static IndexExpression indexExpression(Expression array, Expression index) => new IndexExpression.forTarget_full(array, TokenFactory.token3(TokenType.OPEN_SQUARE_BRACKET), index, TokenFactory.token3(TokenType.CLOSE_SQUARE_BRACKET));
  static InstanceCreationExpression instanceCreationExpression(Keyword keyword, ConstructorName name, List<Expression> arguments) => new InstanceCreationExpression.full(keyword == null ? null : TokenFactory.token(keyword), name, argumentList(arguments));
  static InstanceCreationExpression instanceCreationExpression2(Keyword keyword, TypeName type, List<Expression> arguments) => instanceCreationExpression3(keyword, type, null, arguments);
  static InstanceCreationExpression instanceCreationExpression3(Keyword keyword, TypeName type, String identifier, List<Expression> arguments) => instanceCreationExpression(keyword, new ConstructorName.full(type, identifier == null ? null : TokenFactory.token3(TokenType.PERIOD), identifier == null ? null : identifier2(identifier)), arguments);
  static IntegerLiteral integer(int value) => new IntegerLiteral.full(TokenFactory.token4(TokenType.INT, value.toString()), value);
  static InterpolationExpression interpolationExpression(Expression expression) => new InterpolationExpression.full(TokenFactory.token3(TokenType.STRING_INTERPOLATION_EXPRESSION), expression, TokenFactory.token3(TokenType.CLOSE_CURLY_BRACKET));
  static InterpolationExpression interpolationExpression2(String identifier) => new InterpolationExpression.full(TokenFactory.token3(TokenType.STRING_INTERPOLATION_IDENTIFIER), identifier2(identifier), null);
  static InterpolationString interpolationString(String contents, String value) => new InterpolationString.full(TokenFactory.token2(contents), value);
  static IsExpression isExpression(Expression expression, bool negated, TypeName type) => new IsExpression.full(expression, TokenFactory.token(Keyword.IS), negated ? TokenFactory.token3(TokenType.BANG) : null, type);
  static Label label(String label5) => new Label.full(identifier2(label5), TokenFactory.token3(TokenType.COLON));
  static LabeledStatement labeledStatement(List<Label> labels, Statement statement) => new LabeledStatement.full(labels, statement);
  static LibraryDirective libraryDirective(List<Annotation> metadata, LibraryIdentifier libraryName) => new LibraryDirective.full(null, metadata, TokenFactory.token(Keyword.LIBRARY), libraryName, TokenFactory.token3(TokenType.SEMICOLON));
  static LibraryDirective libraryDirective2(String libraryName) => libraryDirective(new List<Annotation>(), libraryIdentifier2([libraryName]));
  static LibraryIdentifier libraryIdentifier(List<SimpleIdentifier> components) => new LibraryIdentifier.full(list(components));
  static LibraryIdentifier libraryIdentifier2(List<String> components) {
    List<SimpleIdentifier> componentList = new List<SimpleIdentifier>();
    for (String component in components) {
      componentList.add(identifier2(component));
    }
    return new LibraryIdentifier.full(componentList);
  }
  static List<Object> list(List<Object> elements) {
    List<Object> elementList = new List();
    for (Object element in elements) {
      elementList.add(element);
    }
    return elementList;
  }
  static ListLiteral listLiteral(List<Expression> elements) => listLiteral2(null, null, elements);
  static ListLiteral listLiteral2(Keyword keyword, TypeArgumentList typeArguments, List<Expression> elements) => new ListLiteral.full(keyword == null ? null : TokenFactory.token(keyword), null, TokenFactory.token3(TokenType.OPEN_SQUARE_BRACKET), list(elements), TokenFactory.token3(TokenType.CLOSE_SQUARE_BRACKET));
  static MapLiteral mapLiteral(Keyword keyword, TypeArgumentList typeArguments, List<MapLiteralEntry> entries) => new MapLiteral.full(keyword == null ? null : TokenFactory.token(keyword), typeArguments, TokenFactory.token3(TokenType.OPEN_CURLY_BRACKET), list(entries), TokenFactory.token3(TokenType.CLOSE_CURLY_BRACKET));
  static MapLiteral mapLiteral2(List<MapLiteralEntry> entries) => mapLiteral(null, null, entries);
  static MapLiteralEntry mapLiteralEntry(String key, Expression value) => new MapLiteralEntry.full(string2(key), TokenFactory.token3(TokenType.COLON), value);
  static MethodDeclaration methodDeclaration(Keyword modifier, TypeName returnType, Keyword property, Keyword operator, SimpleIdentifier name, FormalParameterList parameters) => new MethodDeclaration.full(null, null, TokenFactory.token(Keyword.EXTERNAL), modifier == null ? null : TokenFactory.token(modifier), returnType, property == null ? null : TokenFactory.token(property), operator == null ? null : TokenFactory.token(operator), name, parameters, emptyFunctionBody());
  static MethodDeclaration methodDeclaration2(Keyword modifier, TypeName returnType, Keyword property, Keyword operator, SimpleIdentifier name, FormalParameterList parameters, FunctionBody body) => new MethodDeclaration.full(null, null, null, modifier == null ? null : TokenFactory.token(modifier), returnType, property == null ? null : TokenFactory.token(property), operator == null ? null : TokenFactory.token(operator), name, parameters, body);
  static MethodInvocation methodInvocation(Expression target, String methodName, List<Expression> arguments) => new MethodInvocation.full(target, target == null ? null : TokenFactory.token3(TokenType.PERIOD), identifier2(methodName), argumentList(arguments));
  static MethodInvocation methodInvocation2(String methodName, List<Expression> arguments) => methodInvocation(null, methodName, arguments);
  static NamedExpression namedExpression(String label6, Expression expression) => new NamedExpression.full(label(label6), expression);
  static DefaultFormalParameter namedFormalParameter(NormalFormalParameter parameter, Expression expression) => new DefaultFormalParameter.full(parameter, ParameterKind.NAMED, expression == null ? null : TokenFactory.token3(TokenType.COLON), expression);
  static NullLiteral nullLiteral() => new NullLiteral.full(TokenFactory.token(Keyword.NULL));
  static ParenthesizedExpression parenthesizedExpression(Expression expression) => new ParenthesizedExpression.full(TokenFactory.token3(TokenType.OPEN_PAREN), expression, TokenFactory.token3(TokenType.CLOSE_PAREN));
  static PartDirective partDirective(List<Annotation> metadata, String url) => new PartDirective.full(null, metadata, TokenFactory.token(Keyword.PART), string2(url), TokenFactory.token3(TokenType.SEMICOLON));
  static PartDirective partDirective2(String url) => partDirective(new List<Annotation>(), url);
  static PartOfDirective partOfDirective(LibraryIdentifier libraryName) => partOfDirective2(new List<Annotation>(), libraryName);
  static PartOfDirective partOfDirective2(List<Annotation> metadata, LibraryIdentifier libraryName) => new PartOfDirective.full(null, metadata, TokenFactory.token(Keyword.PART), TokenFactory.token2("of"), libraryName, TokenFactory.token3(TokenType.SEMICOLON));
  static DefaultFormalParameter positionalFormalParameter(NormalFormalParameter parameter, Expression expression) => new DefaultFormalParameter.full(parameter, ParameterKind.POSITIONAL, expression == null ? null : TokenFactory.token3(TokenType.EQ), expression);
  static PostfixExpression postfixExpression(Expression expression, TokenType operator) => new PostfixExpression.full(expression, TokenFactory.token3(operator));
  static PrefixExpression prefixExpression(TokenType operator, Expression expression) => new PrefixExpression.full(TokenFactory.token3(operator), expression);
  static PropertyAccess propertyAccess(Expression target, SimpleIdentifier propertyName) => new PropertyAccess.full(target, TokenFactory.token3(TokenType.PERIOD), propertyName);
  static PropertyAccess propertyAccess2(Expression target, String propertyName) => new PropertyAccess.full(target, TokenFactory.token3(TokenType.PERIOD), identifier2(propertyName));
  static RedirectingConstructorInvocation redirectingConstructorInvocation(List<Expression> arguments) => redirectingConstructorInvocation2(null, arguments);
  static RedirectingConstructorInvocation redirectingConstructorInvocation2(String constructorName, List<Expression> arguments) => new RedirectingConstructorInvocation.full(TokenFactory.token(Keyword.THIS), constructorName == null ? null : TokenFactory.token3(TokenType.PERIOD), constructorName == null ? null : identifier2(constructorName), argumentList(arguments));
  static ReturnStatement returnStatement() => returnStatement2(null);
  static ReturnStatement returnStatement2(Expression expression) => new ReturnStatement.full(TokenFactory.token(Keyword.RETURN), expression, TokenFactory.token3(TokenType.SEMICOLON));
  static ScriptTag scriptTag(String scriptTag5) => new ScriptTag.full(TokenFactory.token2(scriptTag5));
  static ShowCombinator showCombinator(List<SimpleIdentifier> identifiers) => new ShowCombinator.full(TokenFactory.token2("show"), list(identifiers));
  static ShowCombinator showCombinator2(List<String> identifiers) {
    List<SimpleIdentifier> identifierList = new List<SimpleIdentifier>();
    for (String identifier in identifiers) {
      identifierList.add(identifier2(identifier));
    }
    return new ShowCombinator.full(TokenFactory.token2("show"), identifierList);
  }
  static SimpleFormalParameter simpleFormalParameter(Keyword keyword, String parameterName) => simpleFormalParameter2(keyword, null, parameterName);
  static SimpleFormalParameter simpleFormalParameter2(Keyword keyword, TypeName type, String parameterName) => new SimpleFormalParameter.full(null, null, keyword == null ? null : TokenFactory.token(keyword), type, identifier2(parameterName));
  static SimpleFormalParameter simpleFormalParameter3(String parameterName) => simpleFormalParameter2(null, null, parameterName);
  static SimpleFormalParameter simpleFormalParameter4(TypeName type, String parameterName) => simpleFormalParameter2(null, type, parameterName);
  static StringInterpolation string(List<InterpolationElement> elements) => new StringInterpolation.full(list(elements));
  static SimpleStringLiteral string2(String content) => new SimpleStringLiteral.full(TokenFactory.token2("'${content}'"), content);
  static SuperConstructorInvocation superConstructorInvocation(List<Expression> arguments) => superConstructorInvocation2(null, arguments);
  static SuperConstructorInvocation superConstructorInvocation2(String name, List<Expression> arguments) => new SuperConstructorInvocation.full(TokenFactory.token(Keyword.SUPER), name == null ? null : TokenFactory.token3(TokenType.PERIOD), name == null ? null : identifier2(name), argumentList(arguments));
  static SuperExpression superExpression() => new SuperExpression.full(TokenFactory.token(Keyword.SUPER));
  static SwitchCase switchCase(Expression expression, List<Statement> statements) => switchCase2(new List<Label>(), expression, statements);
  static SwitchCase switchCase2(List<Label> labels, Expression expression, List<Statement> statements) => new SwitchCase.full(labels, TokenFactory.token(Keyword.CASE), expression, TokenFactory.token3(TokenType.COLON), list(statements));
  static SwitchDefault switchDefault(List<Label> labels, List<Statement> statements) => new SwitchDefault.full(labels, TokenFactory.token(Keyword.DEFAULT), TokenFactory.token3(TokenType.COLON), list(statements));
  static SwitchDefault switchDefault2(List<Statement> statements) => switchDefault(new List<Label>(), statements);
  static SwitchStatement switchStatement(Expression expression, List<SwitchMember> members) => new SwitchStatement.full(TokenFactory.token(Keyword.SWITCH), TokenFactory.token3(TokenType.OPEN_PAREN), expression, TokenFactory.token3(TokenType.CLOSE_PAREN), TokenFactory.token3(TokenType.OPEN_CURLY_BRACKET), list(members), TokenFactory.token3(TokenType.CLOSE_CURLY_BRACKET));
  static ThisExpression thisExpression() => new ThisExpression.full(TokenFactory.token(Keyword.THIS));
  static ThrowExpression throwExpression() => throwExpression2(null);
  static ThrowExpression throwExpression2(Expression expression) => new ThrowExpression.full(TokenFactory.token(Keyword.THROW), expression);
  static TopLevelVariableDeclaration topLevelVariableDeclaration(Keyword keyword, TypeName type, List<VariableDeclaration> variables) => new TopLevelVariableDeclaration.full(null, null, variableDeclarationList(keyword, type, variables), TokenFactory.token3(TokenType.SEMICOLON));
  static TopLevelVariableDeclaration topLevelVariableDeclaration2(Keyword keyword, List<VariableDeclaration> variables) => new TopLevelVariableDeclaration.full(null, null, variableDeclarationList(keyword, null, variables), TokenFactory.token3(TokenType.SEMICOLON));
  static TryStatement tryStatement(Block body, Block finallyClause) => tryStatement3(body, new List<CatchClause>(), finallyClause);
  static TryStatement tryStatement2(Block body, List<CatchClause> catchClauses) => tryStatement3(body, list(catchClauses), null);
  static TryStatement tryStatement3(Block body, List<CatchClause> catchClauses, Block finallyClause) => new TryStatement.full(TokenFactory.token(Keyword.TRY), body, catchClauses, finallyClause == null ? null : TokenFactory.token(Keyword.FINALLY), finallyClause);
  static FunctionTypeAlias typeAlias(TypeName returnType, String name, TypeParameterList typeParameters, FormalParameterList parameters) => new FunctionTypeAlias.full(null, null, TokenFactory.token(Keyword.TYPEDEF), returnType, identifier2(name), typeParameters, parameters, TokenFactory.token3(TokenType.SEMICOLON));
  static TypeArgumentList typeArgumentList(List<TypeName> typeNames) => new TypeArgumentList.full(TokenFactory.token3(TokenType.LT), list(typeNames), TokenFactory.token3(TokenType.GT));
  /**
   * Create a type name whose name has been resolved to the given element and whose type has been
   * resolved to the type of the given element.
   * <p>
   * <b>Note:</b> This method does not correctly handle class elements that have type parameters.
   * @param element the element defining the type represented by the type name
   * @return the type name that was created
   */
  static TypeName typeName(ClassElement element55, List<TypeName> arguments) {
    SimpleIdentifier name22 = identifier2(element55.name);
    name22.element = element55;
    TypeName typeName = typeName2(name22, arguments);
    typeName.type = element55.type;
    return typeName;
  }
  static TypeName typeName2(Identifier name, List<TypeName> arguments) {
    if (arguments.length == 0) {
      return new TypeName.full(name, null);
    }
    return new TypeName.full(name, typeArgumentList(arguments));
  }
  static TypeName typeName3(String name, List<TypeName> arguments) {
    if (arguments.length == 0) {
      return new TypeName.full(identifier2(name), null);
    }
    return new TypeName.full(identifier2(name), typeArgumentList(arguments));
  }
  static TypeParameter typeParameter(String name) => new TypeParameter.full(null, null, identifier2(name), null, null);
  static TypeParameter typeParameter2(String name, TypeName bound) => new TypeParameter.full(null, null, identifier2(name), TokenFactory.token(Keyword.EXTENDS), bound);
  static TypeParameterList typeParameterList(List<String> typeNames) {
    List<TypeParameter> typeParameters = new List<TypeParameter>();
    for (String typeName in typeNames) {
      typeParameters.add(typeParameter(typeName));
    }
    return new TypeParameterList.full(TokenFactory.token3(TokenType.LT), typeParameters, TokenFactory.token3(TokenType.GT));
  }
  static VariableDeclaration variableDeclaration(String name) => new VariableDeclaration.full(null, null, identifier2(name), null, null);
  static VariableDeclaration variableDeclaration2(String name, Expression initializer) => new VariableDeclaration.full(null, null, identifier2(name), TokenFactory.token3(TokenType.EQ), initializer);
  static VariableDeclarationList variableDeclarationList(Keyword keyword, TypeName type, List<VariableDeclaration> variables) => new VariableDeclarationList.full(keyword == null ? null : TokenFactory.token(keyword), type, list(variables));
  static VariableDeclarationList variableDeclarationList2(Keyword keyword, List<VariableDeclaration> variables) => variableDeclarationList(keyword, null, variables);
  static VariableDeclarationStatement variableDeclarationStatement(Keyword keyword, TypeName type, List<VariableDeclaration> variables) => new VariableDeclarationStatement.full(variableDeclarationList(keyword, type, variables), TokenFactory.token3(TokenType.SEMICOLON));
  static VariableDeclarationStatement variableDeclarationStatement2(Keyword keyword, List<VariableDeclaration> variables) => variableDeclarationStatement(keyword, null, variables);
  static WhileStatement whileStatement(Expression condition, Statement body) => new WhileStatement.full(TokenFactory.token(Keyword.WHILE), TokenFactory.token3(TokenType.OPEN_PAREN), condition, TokenFactory.token3(TokenType.CLOSE_PAREN), body);
  static WithClause withClause(List<TypeName> types) => new WithClause.full(TokenFactory.token(Keyword.WITH), list(types));
  /**
   * Prevent the creation of instances of this class.
   */
  ASTFactory() {
  }
}
