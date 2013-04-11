library type_translator;


String dartTypeStringToJsType(dartTypeId) {
  String dartType = "${dartTypeId}";
  if (dartType == "String") { return "string"; }
  if (dartType == "int") { return "number"; }
  return "? $dartType";
}

String dartTypeToJsType(dartType) {
  print("dartTypeToJs: $dartType");
  if (dartType == null) { return null; }
  if ("$dartType" == "List<dynamic>")
     return "Array";
  return "unknown";
}
