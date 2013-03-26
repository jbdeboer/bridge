//part of dart2closure;

import 'dart:collection';

import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';

import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/parser.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
import 'package:analyzer_experimental/src/generated/source.dart';


class ErrorListener extends AnalysisErrorListener {
  List<AnalysisError> errors;
  ErrorListener(): errors = new List<AnalysisError>();
  onError(error) => errors.add(error);
}

