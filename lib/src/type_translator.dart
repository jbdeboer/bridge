String dartTypeToJsType(dartType) {
  print("dartTypeToJs: $dartType");
  if (dartType == null) { return null; }
  if ("$dartType" == "List<dynamic>")
     return "Array";
  return "unknown";
}
