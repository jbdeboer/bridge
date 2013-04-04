import 'package:unittest/unittest.dart';

import '../lib/src/jsast/js.dart' as js;

import '../lib/src/visit_result.dart';

final commentA = new js.Comment("Comment A");
final commentB = new js.Comment("Comment B");

main() {
  test('should have default empty list for nodes', () {
    expect(new VisitResult().nodes, equals([]));
    expect(VisitResult.EMPTY.nodes, equals([]));
  });

  test('should store nodes', () {
    expect(new VisitResult([commentA, commentB]).nodes, equals([commentA, commentB]));
  });

  test('should construct with a single node', () {
    expect(VisitResult.fromJsNode(commentA).nodes, equals([commentA]));
  });

  test('should get a null node when there are no nodes', () {
    expect(new VisitResult().node, isNull);
    expect(VisitResult.EMPTY.node, isNull);
  });

  test('should get the only node', () {
    expect(new VisitResult([commentA]).node, equals(commentA));
  });

  test('should raise an exception if you try to get a node when there are more than one', () {
    expect(() => new VisitResult([commentA, commentB]).node, throws);
  });

}
