#!/usr/bin/env dart
// vim: set filetype=dart: -*- mode: dart; -*

/**
 * Translate Dart source code to readable closure flavored Javascript.
 */

import 'dart:collection';
import 'dart:io';

import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';

// From this package.
import 'package:dart2closure/debug.dart';
import 'package:dart2closure/parse.dart';
import 'package:dart2closure/utils.dart';
import 'package:dart2closure/unparse_to_closure.dart';


/**
 * Invoke as,
 *
 *    dart main.dart \
 *        <<<"var x = 1; class A {static staticMethod() {print(1);}}"
 *
 *       or
 *
 *    dart main.dart testdata/ex_01.dart
 */

translateStream(Stream stream) {
  readFullStream(stream).then((text) {
    var ast = parseText(text);
    var js = unparseToClosureJs(ast);
    print(js);
  });
}


main() {
  var fnames = new Options().arguments;
  if (fnames.length > 1) {
    print(dedent('''
      Usage: dart2closure [input.dart]
      
      If no file is passed in, then reads from stdin.'''));
    exit(2);
  }
  var stream = (fnames.length == 1) ? new File(fnames[0]).openRead() : stdin;
  translateStream(stream);
}
