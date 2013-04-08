// This code was auto-generated, is not intended to be edited, and is subject to
// significant change. Please see the README file for more information.

library engine.scanner_test;

import 'dart:collection';
import 'package:analyzer_experimental/src/generated/java_core.dart';
import 'package:analyzer_experimental/src/generated/java_engine.dart';
import 'package:analyzer_experimental/src/generated/java_junit.dart';
import 'package:analyzer_experimental/src/generated/source.dart';
import 'package:analyzer_experimental/src/generated/error.dart';
import 'package:analyzer_experimental/src/generated/scanner.dart';
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
