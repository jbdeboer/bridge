library function_body_visitor;

import 'package:analyzer_experimental/src/generated/ast.dart';
import 'package:analyzer_experimental/src/generated/java_core.dart';

import 'jsast/js.dart' as js;

import 'base_visitor.dart';
import 'lexical_scope.dart';
import 'visit_result.dart';

class FunctionBodyVisitor extends BaseVisitor {
  FunctionBodyVisitor(baseOptions) : super(baseOptions);


}
