library listeners;

import './analyzer_experimental/error.dart';


class ErrorListener extends AnalysisErrorListener {
  List<AnalysisError> errors;
  ErrorListener(): errors = new List<AnalysisError>();
  onError(error) => errors.add(error);
}
