library expression_visitor;

import './analyzer_experimental/ast.dart';
import './analyzer_experimental/element.dart';
import './analyzer_experimental/engine.dart';
import './analyzer_experimental/scanner.dart' as scanner;
import './analyzer_experimental/resolver.dart';
import './analyzer_experimental/java_core.dart';

import 'jsast/js.dart' as js;

import 'base_visitor.dart';
import 'transformers.dart';
import 'utils.dart';
import 'visit_result.dart';
import 'lexical_scope.dart';
import 'ast_factory.dart';
import 'static_type_analyzer.dart';



class ExpressionVisitor extends BaseVisitor {
  ExpressionVisitor(baseOptions) : super(baseOptions);

  js.Expression recurse_(Expression dartExpression) {
    return typedRecurse_(dartExpression).node;
  }

  VisitResult typedRecurse_(Expression dartExpression) {
    return dartExpression.accept(this);
  }

  js.Expression scopedRecurse_(Expression dartExpression, LexicalScope scope) {
    var scopedVisitor = otherVisitor;
    scopedVisitor.scope = scope;
    return dartExpression.accept(scopedVisitor).node;
  }


  VisitResult visitSimpleStringLiteral(node) => VisitResult.fromJsNode(
      new js.LiteralString('"${node.value}"'));

  VisitResult visitIntegerLiteral(node) => VisitResult.fromJsNode(
      new js.LiteralNumber('${node.value}'));

  VisitResult visitDoubleLiteral(node) => VisitResult.fromJsNode(
      new js.LiteralNumber('${node.value}'));

  VisitResult visitBooleanLiteral(node) => VisitResult.fromJsNode(
      new js.LiteralBool(node.value));

  VisitResult visitNullLiteral(NullLiteral node) => VisitResult.fromJsNode(
      new js.LiteralNull());

  VisitResult visitListLiteral(ListLiteral node) {


    node.accept(staticTypeAnalyzer);

    var i = 0;
    var jsExprs = node.elements.elements.map((d) =>
        new js.ArrayElement(i++, recurse_(d))).toList();
    return VisitResult.fromTypedJsNode(new js.ArrayInitializer(i, jsExprs),
         node.staticType
    );
  }

  VisitResult visitMapLiteral(MapLiteral node) {
    var props = node.entries.elements.map((d) =>
      new js.Property(
          recurse_(d.key),
          recurse_(d.value))).toList();
    return VisitResult.fromJsNode(new js.ObjectInitializer(props));
  }

  VisitResult visitAdjacentStrings(AdjacentStrings node) {
    // return a + b + c + ....
    js.Expression genStringTree(List<StringLiteral> strings) {
      if (strings.length == 0) {
        throw new Error('empty AdjacentStrings');
      }
      var first = recurse_(strings[0]);
      if (strings.length == 1) {
        return first;
      }
      return new js.Binary("+", first, genStringTree(strings.sublist(1)));
    }

    return VisitResult.fromJsNode(genStringTree(node.strings.elements));
  }

  VisitResult visitStringInterpolation(StringInterpolation node) {
    return node.accept(this.otherVisitor);
  }

  visitSimpleIdentifier(node) => node.accept(this.otherVisitor);
  visitPrefixedIdentifier(node) => node.accept(this.otherVisitor);

  visitBinaryExpression(BinaryExpression node) => VisitResult.fromJsNode(
      new js.Binary(node.operator.toString(),
                    recurse_(node.leftOperand),
                    recurse_(node.rightOperand)));

  visitCascadeExpression(CascadeExpression node) =>
    VisitResult.fromJsNode(new js.LiteralString('CASCADES NOT IMPLEMENTED'));

  visitConditionalExpression(ConditionalExpression node) =>
    VisitResult.fromJsNode(new js.Conditional(
        recurse_(node.condition),
        recurse_(node.thenExpression),
        recurse_(node.elseExpression)));

  visitMethodInvocation(MethodInvocation node) {
    var args = node.argumentList.arguments.elements.map((d) =>
      recurse_(d)).toList();

    var selector = recurse_(node.methodName);
    js.Expression jsTarget;
    if (node.target == null) {
      jsTarget = selector;
    } else {
      VisitResult target = typedRecurse_(node.target);

      var methodScope = new LexicalScope.clone(scope);
      methodScope.currentScope = LexicalScope.METHOD;
      methodScope.currentType = target.type;

      jsTarget = new js.PropertyAccess.fieldExpression(
          target.node, scopedRecurse_(node.methodName, methodScope));
    }

    return VisitResult.fromJsNode(new js.Call(jsTarget, args));
  }

  visitIndexExpression(IndexExpression node) =>
      VisitResult.fromJsNode(new js.PropertyAccess(
          recurse_(node.realTarget), recurse_(node.index)));

  visitInstanceCreationExpression(InstanceCreationExpression node) =>
      VisitResult.fromJsNode(new js.New(recurse_(node.constructorName.type.name), []));

  visitParenthesizedExpression(ParenthesizedExpression node) =>
      VisitResult.fromJsNode(recurse_(node.expression));

  visitPostfixExpression(PostfixExpression node) =>
      VisitResult.fromJsNode(
          new js.Postfix(node.operator.toString(), recurse_(node.operand)));

  visitPrefixExpression(PrefixExpression node) =>
      VisitResult.fromJsNode(
          new js.Prefix(node.operator.toString(), recurse_(node.operand)));

  visitPropertyAccess(PropertyAccess node) {
      VisitResult target = typedRecurse_(node.target);

      var methodScope = new LexicalScope.clone(scope);
      methodScope.currentScope = LexicalScope.METHOD;
      methodScope.currentType = target.type;
      return VisitResult.fromJsNode(new js.PropertyAccess.fieldExpression(
          recurse_(node.target), scopedRecurse_(node.propertyName, methodScope)));
  }

  visitThisExpression(ThisExpression node) =>
      VisitResult.fromJsNode(new js.This());

 // visitThrowExpression(ThrowExpression node) =>
 //     [new js.Throw(recurse_(node.expression))];

  visitIsExpression(IsExpression node) =>
      VisitResult.fromJsNode(new js.Binary(node.notOperator != null ? '!=' : '==',
          new js.Prefix('typeof', recurse_(node.expression)),
          recurse_(node.type.name)));

  visitAssignmentExpression(AssignmentExpression node) {
      js.Expression lhs = recurse_(node.leftHandSide);
      js.Expression rhs = recurse_(node.rightHandSide);
      if(node.operator.toString() == '=') {
        return VisitResult.fromJsNode(new js.Assignment(lhs, rhs));
      } else {
        return VisitResult.fromJsNode(
            new js.Assignment.compound(lhs, node.operator.toString(), rhs));
      }
  }

  visitFunctionExpression(FunctionExpression node) =>
    VisitResult.fromJsNode(new js.Fun(
        node.parameters.parameters.map((param) => new js.Parameter(param.identifier.name)).toList(),
        node.body.accept(this.otherVisitor).node
    ));
}
