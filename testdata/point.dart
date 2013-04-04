import 'dart:math';

class Point {
  final num x, y;

  Point(this.x, this.y);
  //Point.zero() : x = 0, y = 0;  // Named constructor are not supported

  num distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}
