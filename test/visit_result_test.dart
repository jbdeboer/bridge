import 'package:unittest/unittest.dart';

import '../lib/src/visit_result.dart';

main() {
  test('should have default empty list for statements', () {
    expect(new VisitResult().statements, equals([]));
    expect(VisitResult.EMPTY.statements, equals([]));
  });

  test('should store statements', () {
    expect(new VisitResult(["A", "B"]).statements, equals(["A", "B"]));
  });

  test('should get a null statement when there are no statements', () {
    expect(new VisitResult().statement, isNull);
    expect(VisitResult.EMPTY.statement, isNull);
  });

  test('should get the only statement', () {
    expect(new VisitResult(["A"]).statement, equals("A"));
  });

  test('should raise an exception if you try to get a statement when there are more than one', () {
    expect(() => new VisitResult(["A", "B"]).statement, throws);
  });
}
