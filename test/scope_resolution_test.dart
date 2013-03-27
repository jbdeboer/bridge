import 'package:unittest/unittest.dart';

import 'package:dart2closure/parse.dart';
import 'package:dart2closure/unparse_to_closure.dart';
import 'package:dart2closure/utils.dart';

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
