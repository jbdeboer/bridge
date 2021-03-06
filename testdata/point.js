/**
 * @constructor
 */
function Point(x, y) {
  this.x = x;
  this.y = y;
}

/** @type {number} */
Point.prototype.x;

/** @type {number} */
Point.prototype.y;

/**
 * @param {Point} other .
 */
Point.prototype.distanceTo = function(other) {
  var dx = this.x - other.x;
  var dy = this.y - other.y;
  return Math.sqrt(dx * dx + dy * dy);
};



