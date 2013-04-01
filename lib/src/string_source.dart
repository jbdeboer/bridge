import 'package:analyzer_experimental/src/generated/source.dart';


class StringSource implements Source {
  bool operator ==(Object object) {
    return this == object;
  }
  AnalysisContext get context {
    throw new UnsupportedOperationException();
  }
  void getContents(Source_ContentReceiver receiver) {
    throw new UnsupportedOperationException();
  }
  String get fullName {
    throw new UnsupportedOperationException();
  }
  String get shortName {
    throw new UnsupportedOperationException();
  }
  String get encoding {
    throw new UnsupportedOperationException();
  }
  int get modificationStamp {
    throw new UnsupportedOperationException();
  }
  bool exists() => true;
  bool isInSystemLibrary() {
    throw new UnsupportedOperationException();
  }
  Source resolve(String uri) {
    throw new UnsupportedOperationException();
  }
  Source resolveRelative(Uri uri) {
    throw new UnsupportedOperationException();
  }
}
