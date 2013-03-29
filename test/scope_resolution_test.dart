import 'package:unittest/unittest.dart';

import '../lib/parse.dart';
import '../lib/unparse_to_closure.dart';
import '../lib/utils.dart';

translateText(String text) {
  return unparseToClosureJs(parseText(text));
}


main() {
  // TODO(chirayu): Use testdata files.
  test('nested block variables', () => expect(
    translateText(dedent(r'''
      main() {
        var a = 1, b = 2;
        {
          var a = 2;
          print(a);
        }
        var c = 3;
      }''')),
    equals(dedent(r'''
      {
        var a = 1;
        var b = 2;
        {
          var a = 2;
        }
        var c = 3;
      }'''))));
}
