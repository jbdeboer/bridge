// This code was auto-generated, is not intended to be edited, and is subject to
// significant change. Please see the README file for more information.

library engine.scanner_test;

import 'dart:collection';
import './analyzer_experimental/java_core.dart';
import './analyzer_experimental/java_engine.dart';
import './analyzer_experimental/java_junit.dart';
import './analyzer_experimental/source.dart';
import './analyzer_experimental/error.dart';
import './analyzer_experimental/scanner.dart';
import 'package:unittest/unittest.dart' as _ut;

/**
 * The class {@code TokenFactory} defines utility methods that can be used to create tokens.
 */
class TokenFactory {
  static Token token(Keyword keyword) => new KeywordToken(keyword, 0);
  static Token token2(String lexeme) => new StringToken(TokenType.STRING, lexeme, 0);
  static Token token3(TokenType type) => new Token(type, 0);
  static Token token4(TokenType type, String lexeme) => new StringToken(type, lexeme, 0);
  /**
   * Prevent the creation of instances of this class.
   */
  TokenFactory() {
  }
}
