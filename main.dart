/**
 * Translate Dart source code to readable closure flavored Javascript.
 * Ref:
 *   http://pub.dartlang.org/packages/analyzer_experimental
 *   https://github.com/dart-lang/web-ui/blob/master/lib/src/observable_transform.dart
 */

library dart2closure;

import 'dart:collection';
import 'dart:io';

import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';

import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
import 'package:analyzer_experimental/src/generated/source.dart';

part 'string_source.dart';
part 'listeners.dart';
part 'parse.dart';
part 'debug.dart';


/**
 * TODO(chirayu):  Actually write the code.
 *
 * For now, you can invoke as,
 *
 *    dart main.dart /dev/stdin <<<"var x = 1; class A {static staticMethod() {print(1);}}"""
 *
 *       or
 *
 *    dart main.dart testdata/ex_01.dart
 *
 * And you can see this output:
 *
 *   CompilationUnit: var x = 1; class A {static staticMethod() {print(1);}}
 *     TopLevelVariableDeclaration: var x = 1;
 *       VariableDeclarationList: var x = 1
 *         VariableDeclaration: x = 1
 *           SimpleIdentifier: x
 *           IntegerLiteral: 1
 *     ClassDeclaration: class A {static staticMethod() {print(1);}}
 *       SimpleIdentifier: A
 *       MethodDeclaration: static staticMethod() {print(1);}
 *         SimpleIdentifier: staticMethod
 *         FormalParameterList: ()
 *         BlockFunctionBody: {print(1);}
 *           Block: {print(1);}
 *             ExpressionStatement: print(1);
 *               MethodInvocation: print(1)
 *                 SimpleIdentifier: print
 *                 ArgumentList: (1)
 *                   IntegerLiteral: 1
 */
main() {
  var fnames = new Options().arguments;
  if (fnames.length > 0) {
    for (var fname in fnames) {
      print(dumpAst(parseFile(new File(fname))));
    }
  } else {
    // TODO(chirayu): Reading from stdin is needlessly complicated.
  }
}
