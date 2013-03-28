import 'package:unittest/unittest.dart';

import '../lib/src/jsast/js.dart';

main() {
  test('should output js', () {


    var buffer = prettyPrint(new Return());
    expect(buffer.getText(), equals('return;\n'));
  });
}
