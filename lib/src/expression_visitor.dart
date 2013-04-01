import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'transformers.dart';
import 'utils.dart';
import 'base_visitor.dart';
import 'jsast/js.dart' as js;

class ExpressionVisitor extends BaseVisitor {
  BaseVisitor otherVisitor;

  ExpressionVisitor(this.otherVisitor);

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
        new js.ArrayElement(i++, d.accept(this)[0])).toList();
    return [new js.ArrayInitializer(i, jsExprs)];
  }

  List<js.Node> visitMapLiteral(MapLiteral node) {
    var props = node.entries.elements.map((d) =>
      new js.Property(
          d.key.accept(this)[0],
          d.value.accept(this)[0])).toList();
    return [new js.ObjectInitializer(props)];
  }

  List<js.Node> visitAdjacentStrings(AdjacentStrings node) {
    // return a + b + c + ....
    js.Expression genStringTree(List<StringLiteral> strings) {
      if (strings.length == 0) {
        throw new Error('empty AdjacentStrings');
      }
      var first = strings[0].accept(this)[0];
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
}
