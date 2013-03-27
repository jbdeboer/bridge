import 'dart:async';
import 'dart:io';

/**
 * Dedents and returns text (like Python's textwrap.dedent).
 *
 * Based on: http://hg.python.org/cpython/file/2.7/Lib/textwrap.py
 *
 * Remove any common leading whitespace from every line in `text`.
 *
 * This can be used to make triple-quoted strings line up with the left
 * edge of the display, while still presenting them in the source code
 * in indented form.
 *
 * Note that tabs and spaces are both treated as whitespace, but they
 * are not equal: the lines "  hello" and "\thello" are
 * considered to have no common leading whitespace.
 */
String dedent(String text) {
  final whitespaceOnlyRe = new RegExp(
      '^[ \t]+\$', multiLine: true);
  final leadingWhitespaceRe = new RegExp(
      '(^[ \t]*)([^ \t\n])', multiLine: true);
  // Look for the longest leading string of spaces and tabs common to
  // all lines.
  var margin = null;
  text = text.replaceAll(whitespaceOnlyRe, '');
  var indentMatches = leadingWhitespaceRe.allMatches(text);
  for (var indentMatch in indentMatches) {
    var indent = indentMatch.group(1);
    if (margin == null) {
      margin = indent;
    } else if (indent.startsWith(margin)) {
      // Current line more deeply indented than previous winner:
      // no change (previous winner is still on top).
    } else if (margin.startsWith(indent)) {
      // Current line consistent with and no deeper than previous winner:
      // it's the new winner.
      margin = indent;
    } else {
      // Current line and previous winner have no common whitespace:
      // there is no margin.
      margin = '';
    }
  }
  if (margin != '' && margin != null) {
    var dedentRe = new RegExp('^${margin}', multiLine: true);
    text = text.replaceAll(dedentRe, '');
  }
  return text;
}


/**
 * Read entire [stream] as a [String].  Returns a [Future].
 */
String readFullStream(Stream stream) {
  var parts = <String>[];
  var completer = new Completer();

  stream
      .transform(new StringDecoder())
      .listen(
          (String text) => parts.add(text),
          onDone: () => completer.complete(parts.join()),
          onError: (e) => completer.completeError(e));
  return completer.future;
}

/**
 * A StringBuffer that can be used in place of a PrintWriter.
 */
class StringWriter extends StringBuffer {
  print(x) => write(x);
  println(x) => writeln(x);
}


class IndentedStringBuffer extends StringWriter {
  num _level = 0;
  String _indent = '';
  bool pendingNewline = false;

  static num getIndentString(num level) {
    return new List<String>(level).map((_) => '  ').join();
  }

  num get level => _level;
  set level(level) {
    _level = level;
    _indent = getIndentString(level);
  }

  flushNewline() {
    if (pendingNewline) {
      super.write("\n$_indent");
    }
    pendingNewline = false;
  }

  write(obj) {
    flushNewline();
    var s = obj.toString();
    if (s.endsWith("\n")) {
      pendingNewline = true;
      s = s.slice(0, -1);
    }
    s = s.replaceAll("\n", "\n$_indent");
    super.write(s);
  }

  writeln([Object obj = ""]) {
    flushNewline();
    write(obj);
    write("\n");
  }
}
