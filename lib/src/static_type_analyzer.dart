library static_type_analyzer;

import 'analyzer_experimental/ast.dart';
import 'analyzer_experimental/element.dart';
import 'analyzer_experimental/engine.dart';
import 'analyzer_experimental/scanner.dart' as scanner;
import 'analyzer_experimental/resolver.dart';
import 'analyzer_experimental/java_core.dart';

import 'jsast/js.dart' as js;

import 'base_visitor.dart';
import 'transformers.dart';
import 'utils.dart';
import 'visit_result.dart';
import 'lexical_scope.dart';
import 'ast_factory.dart';

genListType() {
  ClassElementImpl element = new ClassElementImpl(ASTFactory.identifier2('List'));
  var ret = new InterfaceTypeImpl.con1(element);
  ret.typeArguments = [new DynamicTypeImpl()];
  return ret;
}

getDynamicType() {
  return new DynamicTypeImpl();
}

class LazyTypeProvider implements TypeProvider {
  InterfaceType get boolType => null;
  Type2 get bottomType => null;
  InterfaceType get doubleType => null;
  Type2 get dynamicType => getDynamicType();
  InterfaceType get functionType => null;
  InterfaceType get intType => null;
  InterfaceType get listType => genListType();
  InterfaceType get mapType => null;
  InterfaceType get objectType => null;
  InterfaceType get stackTraceType => null;
  InterfaceType get stringType => null;
  InterfaceType get typeType => null;
}


TypeProvider tpi = new LazyTypeProvider();
StaticTypeAnalyzer staticTypeAnalyzer = new StaticTypeAnalyzer.withTypeProvider(tpi);