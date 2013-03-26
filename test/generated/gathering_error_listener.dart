library engine.gathering_error_listener;

import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/source.dart';

class GatheringErrorListener implements AnalysisErrorListener {
/**
   * The source being parsed.
   */
  String _rawSource;
/**
   * The source being parsed after inserting a marker at the beginning and end of the range of the
   * most recent error.
   */
  String _markedSource;
/**
   * A list containing the errors that were collected.
   */
  List<AnalysisError> _errors = new List<AnalysisError>();
/**
   * A table mapping sources to the line information for the source.
   */
  Map<Source, LineInfo> _lineInfoMap = new Map<Source, LineInfo>();
/**
   * An empty array of errors used when no errors are expected.
   */
  static List<AnalysisError> _NO_ERRORS = new List<AnalysisError>(0);
/**
   * Initialize a newly created error listener to collect errors.
   */
  GatheringErrorListener() : super() {
    _jtd_constructor_317_impl();
  }
  _jtd_constructor_317_impl() {
  }
/**
   * Initialize a newly created error listener to collect errors.
   */
  GatheringErrorListener.con1(String rawSource2) {
    _jtd_constructor_318_impl(rawSource2);
  }
  _jtd_constructor_318_impl(String rawSource2) {
    this._rawSource = rawSource2;
    this._markedSource = rawSource2;
  }
/**
   * Assert that the number of errors that have been gathered matches the number of errors that are
   * given and that they have the expected error codes and locations. The order in which the errors
   * were gathered is ignored.
   * @param errorCodes the errors that should have been gathered
   * @throws AssertionFailedError if a different number of errors have been gathered than were
   * expected or if they do not have the same codes and locations
   */
  void assertErrors(List<AnalysisError> expectedErrors) {
    if (_errors.length != expectedErrors.length) {
      fail(expectedErrors);
    }
    List<AnalysisError> remainingErrors = new List<AnalysisError>();
    for (AnalysisError error in expectedErrors) {
      remainingErrors.add(error);
    }
    for (AnalysisError error in _errors) {
      if (!foundAndRemoved(remainingErrors, error)) {
        fail(expectedErrors);
      }
    }
  }
/**
   * Assert that the number of errors that have been gathered matches the number of errors that are
   * given and that they have the expected error codes. The order in which the errors were gathered
   * is ignored.
   * @param expectedErrorCodes the error codes of the errors that should have been gathered
   * @throws AssertionFailedError if a different number of errors have been gathered than were
   * expected
   */
  void assertErrors2(List<ErrorCode> expectedErrorCodes) {
    JavaStringBuilder builder = new JavaStringBuilder();
    Map<ErrorCode, int> expectedCounts = new Map<ErrorCode, int>();
    for (ErrorCode code in expectedErrorCodes) {
      int count = expectedCounts[code];
      if (count == null) {
        count = 1;
      } else {
        count = count + 1;
      }
      expectedCounts[code] = count;
    }
    Map<ErrorCode, List<AnalysisError>> errorsByCode = new Map<ErrorCode, List<AnalysisError>>();
    for (AnalysisError error in _errors) {
      ErrorCode code = error.errorCode;
      List<AnalysisError> list = errorsByCode[code];
      if (list == null) {
        list = new List<AnalysisError>();
        errorsByCode[code] = list;
      }
      list.add(error);
    }
    for (MapEntry<ErrorCode, int> entry in getMapEntrySet(expectedCounts)) {
      ErrorCode code = entry.getKey();
      int expectedCount = entry.getValue();
      int actualCount;
      List<AnalysisError> list = errorsByCode.remove(code);
      if (list == null) {
        actualCount = 0;
      } else {
        actualCount = list.length;
      }
      if (actualCount != expectedCount) {
        if (builder.length == 0) {
          builder.append("Expected ");
        } else {
          builder.append("; ");
        }
        builder.append(expectedCount);
        builder.append(" errors of type ");
        builder.append(code);
        builder.append(", found ");
        builder.append(actualCount);
      }
    }
    for (MapEntry<ErrorCode, List<AnalysisError>> entry in getMapEntrySet(errorsByCode)) {
      ErrorCode code = entry.getKey();
      List<AnalysisError> actualErrors = entry.getValue();
      int actualCount = actualErrors.length;
      if (builder.length == 0) {
        builder.append("Expected ");
      } else {
        builder.append("; ");
      }
      builder.append("0 errors of type ");
      builder.append(code);
      builder.append(", found ");
      builder.append(actualCount);
      builder.append(" (");
      for (int i = 0; i < actualErrors.length; i++) {
        AnalysisError error = actualErrors[i];
        if (i > 0) {
          builder.append(", ");
        }
        builder.append(error.offset);
      }
      builder.append(")");
    }
    if (builder.length > 0) {
      JUnitTestCase.fail(builder.toString());
    }
  }
/**
   * Assert that the number of errors that have been gathered matches the number of severities that
   * are given and that there are the same number of errors and warnings as specified by the
   * argument. The order in which the errors were gathered is ignored.
   * @param expectedSeverities the severities of the errors that should have been gathered
   * @throws AssertionFailedError if a different number of errors have been gathered than were
   * expected
   */
  void assertErrors3(List<ErrorSeverity> expectedSeverities) {
    int expectedErrorCount = 0;
    int expectedWarningCount = 0;
    for (ErrorSeverity severity in expectedSeverities) {
      if (identical(severity, ErrorSeverity.ERROR)) {
        expectedErrorCount++;
      } else {
        expectedWarningCount++;
      }
    }
    int actualErrorCount = 0;
    int actualWarningCount = 0;
    for (AnalysisError error in _errors) {
      if (identical(error.errorCode.errorSeverity, ErrorSeverity.ERROR)) {
        actualErrorCount++;
      } else {
        actualWarningCount++;
      }
    }
    if (expectedErrorCount != actualErrorCount || expectedWarningCount != actualWarningCount) {
      JUnitTestCase.fail("Expected ${expectedErrorCount} errors and ${expectedWarningCount} warnings, found ${actualErrorCount} errors and ${actualWarningCount} warnings");
    }
  }
/**
   * Assert that no errors have been gathered.
   * @throws AssertionFailedError if any errors have been gathered
   */
  void assertNoErrors() {
    assertErrors(_NO_ERRORS);
  }
/**
   * Return the errors that were collected.
   * @return the errors that were collected
   */
  List<AnalysisError> get errors => _errors;
/**
   * Return {@code true} if an error with the given error code has been gathered.
   * @param errorCode the error code being searched for
   * @return {@code true} if an error with the given error code has been gathered
   */
  bool hasError(ErrorCode errorCode5) {
    for (AnalysisError error in _errors) {
      if (identical(error.errorCode, errorCode5)) {
        return true;
      }
    }
    return false;
  }
  void onError(AnalysisError error) {
    if (_rawSource != null) {
      int left = error.offset;
      int right = left + error.length - 1;
      _markedSource = "${_rawSource.substring(0, left)}^${_rawSource.substring(left, right)}^${_rawSource.substring(right)}";
    }
    _errors.add(error);
  }
/**
   * Set the line information associated with the given source to the given information.
   * @param source the source with which the line information is associated
   * @param lineStarts the line start information to be associated with the source
   */
  void setLineInfo(Source source, List<int> lineStarts) {
    _lineInfoMap[source] = new LineInfo(lineStarts);
  }
/**
   * Set the line information associated with the given source to the given information.
   * @param source the source with which the line information is associated
   * @param lineInfo the line information to be associated with the source
   */
  void setLineInfo2(Source source, LineInfo lineInfo) {
    _lineInfoMap[source] = lineInfo;
  }
/**
   * Return {@code true} if the two errors are equivalent.
   * @param firstError the first error being compared
   * @param secondError the second error being compared
   * @return {@code true} if the two errors are equivalent
   */
  bool equals(AnalysisError firstError, AnalysisError secondError) => identical(firstError.errorCode, secondError.errorCode) && firstError.offset == secondError.offset && firstError.length == secondError.length && equals3(firstError.source, secondError.source);
/**
   * Return {@code true} if the two sources are equivalent.
   * @param firstSource the first source being compared
   * @param secondSource the second source being compared
   * @return {@code true} if the two sources are equivalent
   */
  bool equals3(Source firstSource, Source secondSource) {
    if (firstSource == null) {
      return secondSource == null;
    } else if (secondSource == null) {
      return false;
    }
    return firstSource == secondSource;
  }
/**
   * Assert that the number of errors that have been gathered matches the number of errors that are
   * given and that they have the expected error codes. The order in which the errors were gathered
   * is ignored.
   * @param errorCodes the errors that should have been gathered
   * @throws AssertionFailedError with
   */
  void fail(List<AnalysisError> expectedErrors) {
    PrintStringWriter writer = new PrintStringWriter();
    writer.print("Expected ");
    writer.print(expectedErrors.length);
    writer.print(" errors:");
    for (AnalysisError error in expectedErrors) {
      Source source13 = error.source;
      LineInfo lineInfo = _lineInfoMap[source13];
      writer.println();
      if (lineInfo == null) {
        int offset10 = error.offset;
        writer.printf("  %s %s (%d..%d)", [source13 == null ? "" : source13.shortName, error.errorCode, offset10, offset10 + error.length]);
      } else {
        LineInfo_Location location = lineInfo.getLocation(error.offset);
        writer.printf("  %s %s (%d, %d/%d)", [source13 == null ? "" : source13.shortName, error.errorCode, location.lineNumber, location.columnNumber, error.length]);
      }
    }
    writer.println();
    writer.print("found ");
    writer.print(_errors.length);
    writer.print(" errors:");
    for (AnalysisError error in _errors) {
      Source source14 = error.source;
      LineInfo lineInfo = _lineInfoMap[source14];
      writer.println();
      if (lineInfo == null) {
        int offset11 = error.offset;
        writer.printf("  %s %s (%d..%d): %s", [source14 == null ? "" : source14.shortName, error.errorCode, offset11, offset11 + error.length, error.message]);
      } else {
        LineInfo_Location location = lineInfo.getLocation(error.offset);
        writer.printf("  %s %s (%d, %d/%d): %s", [source14 == null ? "" : source14.shortName, error.errorCode, location.lineNumber, location.columnNumber, error.length, error.message]);
      }
    }
    JUnitTestCase.fail(writer.toString());
  }
/**
   * Search through the given list of errors for an error that is equal to the target error. If one
   * is found, remove it from the list and return {@code true}, otherwise return {@code false}without modifying the list.
   * @param errors the errors through which we are searching
   * @param targetError the error being searched for
   * @return {@code true} if the error is found and removed from the list
   */
  bool foundAndRemoved(List<AnalysisError> errors, AnalysisError targetError) {
    for (AnalysisError error in errors) {
      if (equals(error, targetError)) {
        errors.remove(error);
        return true;
      }
    }
    return true;
  }
}
