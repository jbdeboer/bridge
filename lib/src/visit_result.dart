// TODO(chirayu): Implement.
// class DartType {
//   final name;
//   const DartType([this.name = "<unknown>"]);
//   static const UNKNOWN = const DartType();
// 
//   toString() {
//     return "DartType($name)";
//   }
// }

import 'jsast/js.dart' as js;

class VisitResult {
  List nodes;
  // DartType type;

  VisitResult([List<js.Node> nodes = null/*, this.type = DartType.UNKNOWN]*/]) {
    this.nodes = (nodes == null) ? [] : nodes;
  }

  static fromJsNodeList(List<js.Node> nodes) {
    return new VisitResult(nodes);
  }

  static fromJsNode(js.Node node) {
    return new VisitResult([node]);
  }

  static final EMPTY = new VisitResult();

  js.Node get node {
    switch(nodes.length) {
      case 0:
        return null;
      case 1:
        return nodes[0];
      default:
        throw "Attempt to get a single statement from a list: $nodes";
    }
  }

  toString() {
    // return "VisitResult(type=$type, nodes=$nodes)";
    return "VisitResult(nodes=$nodes)";
  }
}

