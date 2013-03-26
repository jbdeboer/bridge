part of dart2closure;

class ErrorListener extends AnalysisErrorListener {
  List<AnalysisError> errors;
  ErrorListener(): errors = new List<AnalysisError>();
  onError(error) => errors.add(error);
}

