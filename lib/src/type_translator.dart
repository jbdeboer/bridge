library type_translator;

String dartTypeToJsType(dartType) {
  if (dartType == null) { return null; }
  if ("$dartType" == "List<dynamic>")
     return "Array";
  return "unknown";
}
