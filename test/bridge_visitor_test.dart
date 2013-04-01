import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';


import 'package:unittest/unittest.dart';
import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';

import '../lib/src/bridge_parser.dart';
import '../lib/src/bridge_visitor.dart';
import '../lib/src/listeners.dart';
import '../lib/src/parse.dart';
import '../lib/src/utils.dart';

class BVT {
  static expectParse(String dart, String js) {
    expect(stringBridge(dart), equals(js));
  }
}

main() {

}
