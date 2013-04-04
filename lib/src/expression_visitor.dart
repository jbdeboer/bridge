import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';

import 'jsast/js.dart' as js;

import 'base_visitor.dart';
import 'transformers.dart';
import 'utils.dart';
import 'visit_result.dart';

class ExpressionVisitor extends BaseVisitor {
  ExpressionVisitor(baseOptions) : super(baseOptions);

  js.Expression recurse_(Expression dartExpression) {
    return dartExpression.accept(this).node;
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
    var i = 0;
    var jsExprs = node.elements.elements.map((d) =>
        new js.ArrayElement(i++, recurse_(d))).toList();
    return VisitResult.fromJsNode(new js.ArrayInitializer(i, jsExprs));
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
    js.Expression target = node.target != null ?
         new js.PropertyAccess.fieldExpression(
             recurse_(node.target), recurse_(node.methodName)) : selector;
    return VisitResult.fromJsNode(new js.Call(target, args));
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

  visitPropertyAccess(PropertyAccess node) =>
      VisitResult.fromJsNode(new js.PropertyAccess.fieldExpression(
          recurse_(node.target), recurse_(node.propertyName)));

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
}
