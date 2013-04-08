import 'package:analyzer_experimental/src/generated/element.dart';
import 'ast_factory.dart';

final ClassElementImpl object = classElement("Object", (null as InterfaceType), []);

classElement(String name, InterfaceType superType, params) {
   ClassElementImpl element = new ClassElementImpl(ASTFactory.identifier2(name));
   element.supertype = superType;
   InterfaceTypeImpl type = new InterfaceTypeImpl.con1(element);
   element.type = type;
   // NOTE: params are not supported.
   return element;
}

Type2 typeFactory(String name, [List<String> typeParams = null]) {
  var ret = new InterfaceTypeImpl.con1(classElement(name, object.type, []));
  if (typeParams != null) {
    // TODO implement passing typeParams
    ret.typeArguments = [new DynamicTypeImpl()];
  }
  return ret;
}
