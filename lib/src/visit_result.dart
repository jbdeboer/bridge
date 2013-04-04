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

class VisitResult {
  List statements;
  // DartType type;

  VisitResult([statements = null/*, this.type = DartType.UNKNOWN]*/]) {
    this.statements = (statements == null) ? [] : statements;
  }

  static final EMPTY = new VisitResult();

  get statement {
    switch(statements.length) {
      case 0:
        return null;
      case 1:
        return statements[0];
      default:
        throw "Attempt to get a single statement from a list: $statements";
    }
  }

  toString() {
    // return "VisitResult(type=$type, statements=$statements)";
    return "VisitResult(statements=$statements)";
  }
}

