import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'transformers.dart';
import 'utils.dart';
import 'base_visitor.dart';
import 'jsast/js.dart' as js;

class ExpressionVisitor extends BaseVisitor {
  ExpressionVisitor(otherVisitor) : super(otherVisitor);

  js.Expression recurse_(Expression dartExpression) =>
      dartExpression.accept(this)[0];

  List<js.Node> visitSimpleStringLiteral(node) =>
      [new js.LiteralString('"${node.value}"')];

  List<js.Node> visitIntegerLiteral(node) =>
      [new js.LiteralNumber('${node.value}')];

  List<js.Node> visitDoubleLiteral(node) =>
      [new js.LiteralNumber('${node.value}')];

  List<js.Node> visitBooleanLiteral(node) =>
      [new js.LiteralBool(node.value)];

  List<js.Node> visitNullLiteral(NullLiteral node) =>
      [new js.LiteralNull()];

  List<js.Node> visitListLiteral(ListLiteral node) {
    var i = 0;
    var jsExprs = node.elements.elements.map((d) =>
        new js.ArrayElement(i++, recurse_(d))).toList();
    return [new js.ArrayInitializer(i, jsExprs)];
  }

  List<js.Node> visitMapLiteral(MapLiteral node) {
    var props = node.entries.elements.map((d) =>
      new js.Property(
          recurse_(d.key),
          recurse_(d.value))).toList();
    return [new js.ObjectInitializer(props)];
  }

  List<js.Node> visitAdjacentStrings(AdjacentStrings node) {
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
    return [genStringTree(node.strings.elements)];
  }

  List<js.Node> visitStringInterpolation(StringInterpolation node) {
    return node.accept(this.otherVisitor);
  }

  visitSimpleIdentifier(node) => node.accept(this.otherVisitor);
  visitPrefixedIdentifier(node) => node.accept(this.otherVisitor);

  visitBinaryExpression(BinaryExpression node) =>
    [new js.Binary(node.operator.toString(),
      recurse_(node.leftOperand),
      recurse_(node.rightOperand))];

  visitCascadeExpression(CascadeExpression node) =>
    [new js.LiteralString('CASCADES NOT IMPLEMENTED')];

  visitConditionalExpression(ConditionalExpression node) =>
    [new js.Conditional(
        recurse_(node.condition),
        recurse_(node.thenExpression),
        recurse_(node.elseExpression))];

  visitMethodInvocation(MethodInvocation node) {
    var args = node.argumentList.arguments.elements.map((d) =>
      recurse_(d)).toList();

    var selector = recurse_(node.methodName);
    js.Expression target = node.target != null ?
         new js.PropertyAccess.fieldExpression(
             recurse_(node.target), recurse_(node.methodName)) : selector;
    return [new js.Call(target, args)];
  }

  visitIndexExpression(IndexExpression node) =>
      [new js.PropertyAccess(recurse_(node.realTarget), recurse_(node.index))];

  visitInstanceCreationExpression(InstanceCreationExpression node) =>
      [new js.New(recurse_(node.constructorName.type.name), [])];

  visitParenthesizedExpression(ParenthesizedExpression node) =>
      [recurse_(node.expression)];

  visitPostfixExpression(PostfixExpression node) =>
      [new js.Postfix(node.operator.toString(), recurse_(node.operand))];

  visitPrefixExpression(PrefixExpression node) =>
      [new js.Prefix(node.operator.toString(), recurse_(node.operand))];

  visitPropertyAccess(PropertyAccess node) =>
      [new js.PropertyAccess.fieldExpression(
          recurse_(node.target), recurse_(node.propertyName))];

  visitThisExpression(ThisExpression node) =>
      [new js.This()];

 // visitThrowExpression(ThrowExpression node) =>
 //     [new js.Throw(recurse_(node.expression))];

  visitIsExpression(IsExpression node) =>
      [new js.Binary(node.notOperator != null ? '!=' : '==',
          new js.Prefix('typeof', recurse_(node.expression)),
          recurse_(node.type.name))];

  visitAssignmentExpression(AssignmentExpression node) {
      js.Expression lhs = recurse_(node.leftHandSide);
      js.Expression rhs = recurse_(node.rightHandSide);
      if(node.operator.toString() == '=') {
        return [new js.Assignment(lhs, rhs)];
      } else {
        return [new js.Assignment.compound(lhs, node.operator.toString(), rhs)];
      }
  }

}
