import 'package:unittest/unittest.dart';
//import 'package:analyzer_experimental/src/generated/ast.dart';

import '../lib/src/type_translator.dart';

main() {
  test('should translate a missing type into a missing type', () {
    expect(dartTypeToJsType(null), equals(null));
  });

  test('should translate a type into an array', () {
    expect(dartTypeToJsType("List<dynamic>"), equals("Array"));
  });
}
