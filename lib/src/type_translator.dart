library type_translator;


String dartTypeIdToJsType(dartTypeId) {
  if (dartTypeId == null) { return "?"; }

  String dartType = "${dartTypeId.name}";
  if (dartType == "bool") { return "boolean"; }
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
