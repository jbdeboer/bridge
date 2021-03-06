// This code was auto-generated, is not intended to be edited, and is subject to
// significant change. Please see the README file for more information.

library engine;

import 'java_core.dart';
import 'java_engine.dart';
import 'dart:collection' show HasNextIterator;
import 'error.dart';
import 'source.dart';
import 'scanner.dart' show Token, CharBufferScanner, StringScanner;
import 'ast.dart' show CompilationUnit, Directive, PartOfDirective;
import 'parser.dart' show Parser;
import 'element.dart';
import 'resolver.dart' show Namespace, NamespaceBuilder, LibraryResolver, HtmlUnitBuilder;
import 'html.dart' show XmlTagNode, XmlAttributeNode, SimpleXmlVisitor, HtmlScanner, HtmlScanResult, HtmlParser, HtmlParseResult, HtmlUnit;

/**
 * The unique instance of the class {@code AnalysisEngine} serves as the entry point for the
 * functionality provided by the analysis engine.
 * @coverage dart.engine
 */
class AnalysisEngine {
  /**
   * The suffix used for Dart source files.
   */
  static String SUFFIX_DART = "dart";
  /**
   * The short suffix used for HTML files.
   */
  static String SUFFIX_HTM = "htm";
  /**
   * The long suffix used for HTML files.
   */
  static String SUFFIX_HTML = "html";
  /**
   * The unique instance of this class.
   */
  static AnalysisEngine _UniqueInstance = new AnalysisEngine();
  /**
   * Return the unique instance of this class.
   * @return the unique instance of this class
   */
  static AnalysisEngine get instance => _UniqueInstance;
  /**
   * Return {@code true} if the given file name is assumed to contain Dart source code.
   * @param fileName the name of the file being tested
   * @return {@code true} if the given file name is assumed to contain Dart source code
   */
  static bool isDartFileName(String fileName) {
    if (fileName == null) {
      return false;
    }
    return javaStringEqualsIgnoreCase(FileNameUtilities.getExtension(fileName), SUFFIX_DART);
  }
  /**
   * Return {@code true} if the given file name is assumed to contain HTML.
   * @param fileName the name of the file being tested
   * @return {@code true} if the given file name is assumed to contain HTML
   */
  static bool isHtmlFileName(String fileName) {
    if (fileName == null) {
      return false;
    }
    String extension = FileNameUtilities.getExtension(fileName);
    return javaStringEqualsIgnoreCase(extension, SUFFIX_HTML) || javaStringEqualsIgnoreCase(extension, SUFFIX_HTM);
  }
  /**
   * The logger that should receive information about errors within the analysis engine.
   */
  Logger _logger = Logger.NULL;
  /**
   * Prevent the creation of instances of this class.
   */
  AnalysisEngine() : super() {
  }
  /**
   * Create a new context in which analysis can be performed.
   * @return the analysis context that was created
   */
  AnalysisContext createAnalysisContext() => new AnalysisContextImpl();
  /**
   * Return the logger that should receive information about errors within the analysis engine.
   * @return the logger that should receive information about errors within the analysis engine
   */
  Logger get logger => _logger;
  /**
   * Set the logger that should receive information about errors within the analysis engine to the
   * given logger.
   * @param logger the logger that should receive information about errors within the analysis
   * engine
   */
  void set logger(Logger logger2) {
    this._logger = logger2 == null ? Logger.NULL : logger2;
  }
}
/**
 * The interface {@code AnalysisContext} defines the behavior of objects that represent a context in
 * which a single analysis can be performed and incrementally maintained. The context includes such
 * information as the version of the SDK being analyzed against as well as the package-root used to
 * resolve 'package:' URI's. (Both of which are known indirectly through the {@link SourceFactorysource factory}.)
 * <p>
 * An analysis context also represents the state of the analysis, which includes knowing which
 * sources have been included in the analysis (either directly or indirectly) and the results of the
 * analysis. Sources must be added and removed from the context using the method{@link #applyChanges(ChangeSet)}, which is also used to notify the context when sources have been
 * modified and, consequently, previously known results might have been invalidated.
 * <p>
 * There are two ways to access the results of the analysis. The most common is to use one of the
 * 'get' methods to access the results. The 'get' methods have the advantage that they will always
 * return quickly, but have the disadvantage that if the results are not currently available they
 * will return either nothing or in some cases an incomplete result. The second way to access
 * results is by using one of the 'compute' methods. The 'compute' methods will always attempt to
 * compute the requested results but might block the caller for a significant period of time.
 * <p>
 * When results have been invalidated, have never been computed (as is the case for newly added
 * sources), or have been removed from the cache, they are <b>not</b> automatically recreated. They
 * will only be recreated if one of the 'compute' methods is invoked.
 * <p>
 * However, this is not always acceptable. Some clients need to keep the analysis results
 * up-to-date. For such clients there is a mechanism that allows them to incrementally perform
 * needed analysis and get notified of the consequent changes to the analysis results. This
 * mechanism is realized by the method {@link #performAnalysisTask()}.
 * <p>
 * Analysis engine allows for having more than one context. This can be used, for example, to
 * perform one analysis based on the state of files on disk and a separate analysis based on the
 * state of those files in open editors. It can also be used to perform an analysis based on a
 * proposed future state, such as the state after a refactoring.
 */
abstract class AnalysisContext {
  /**
   * Apply the changes specified by the given change set to this context. Any analysis results that
   * have been invalidated by these changes will be removed.
   * @param changeSet a description of the changes that are to be applied
   */
  void applyChanges(ChangeSet changeSet);
  /**
   * Return an array containing all of the errors associated with the given source. If the errors
   * are not already known then the source will be analyzed in order to determine the errors
   * associated with it.
   * @param source the source whose errors are to be returned
   * @return all of the errors associated with the given source
   * @throws AnalysisException if the errors could not be determined because the analysis could not
   * be performed
   * @see #getErrors(Source)
   */
  List<AnalysisError> computeErrors(Source source);
  /**
   * Return the element model corresponding to the HTML file defined by the given source. If the
   * element model does not yet exist it will be created. The process of creating an element model
   * for an HTML file can long-running, depending on the size of the file and the number of
   * libraries that are defined in it (via script tags) that also need to have a model built for
   * them.
   * @param source the source defining the HTML file whose element model is to be returned
   * @return the element model corresponding to the HTML file defined by the given source
   * @throws AnalysisException if the element model could not be determined because the analysis
   * could not be performed
   * @see #getHtmlElement(Source)
   */
  HtmlElement computeHtmlElement(Source source);
  /**
   * Return the kind of the given source, computing it's kind if it is not already known. Return{@link SourceKind#UNKNOWN} if the source is not contained in this context.
   * @param source the source whose kind is to be returned
   * @return the kind of the given source
   * @see #getKindOf(Source)
   */
  SourceKind computeKindOf(Source source);
  /**
   * Return the element model corresponding to the library defined by the given source. If the
   * element model does not yet exist it will be created. The process of creating an element model
   * for a library can long-running, depending on the size of the library and the number of
   * libraries that are imported into it that also need to have a model built for them.
   * @param source the source defining the library whose element model is to be returned
   * @return the element model corresponding to the library defined by the given source
   * @throws AnalysisException if the element model could not be determined because the analysis
   * could not be performed
   * @see #getLibraryElement(Source)
   */
  LibraryElement computeLibraryElement(Source source);
  /**
   * Return the line information for the given source, or {@code null} if the source is not of a
   * recognized kind (neither a Dart nor HTML file). If the line information was not previously
   * known it will be created. The line information is used to map offsets from the beginning of the
   * source to line and column pairs.
   * @param source the source whose line information is to be returned
   * @return the line information for the given source
   * @throws AnalysisException if the line information could not be determined because the analysis
   * could not be performed
   * @see #getLineInfo(Source)
   */
  LineInfo computeLineInfo(Source source);
  /**
   * Create a new context in which analysis can be performed. Any sources in the specified container
   * will be removed from this context and added to the newly created context.
   * @param container the container containing sources that should be removed from this context and
   * added to the returned context
   * @return the analysis context that was created
   */
  AnalysisContext extractContext(SourceContainer container);
  /**
   * Return the element referenced by the given location, or {@code null} if the element is not
   * immediately available or if there is no element with the given location. The latter condition
   * can occur, for example, if the location describes an element from a different context or if the
   * element has been removed from this context as a result of some change since it was originally
   * obtained.
   * @param location the reference describing the element to be returned
   * @return the element referenced by the given location
   */
  Element getElement(ElementLocation location);
  /**
   * Return an array containing all of the errors associated with the given source. The array will
   * be empty if the source is not known to this context or if there are no errors in the source.
   * The errors contained in the array can be incomplete.
   * @param source the source whose errors are to be returned
   * @return all of the errors associated with the given source
   * @see #computeErrors(Source)
   */
  List<AnalysisError> getErrors(Source source);
  /**
   * Return the element model corresponding to the HTML file defined by the given source, or{@code null} if the source does not represent an HTML file, the element representing the file
   * has not yet been created, or the analysis of the HTML file failed for some reason.
   * @param source the source defining the HTML file whose element model is to be returned
   * @return the element model corresponding to the HTML file defined by the given source
   * @see #computeHtmlElement(Source)
   */
  HtmlElement getHtmlElement(Source source);
  /**
   * Return the sources for the HTML files that reference the given compilation unit. If the source
   * does not represent a Dart source or is not known to this context, the returned array will be
   * empty. The contents of the array can be incomplete.
   * @param source the source referenced by the returned HTML files
   * @return the sources for the HTML files that reference the given compilation unit
   */
  List<Source> getHtmlFilesReferencing(Source source);
  /**
   * Return an array containing all of the sources known to this context that represent HTML files.
   * The contents of the array can be incomplete.
   * @return the sources known to this context that represent HTML files
   */
  List<Source> get htmlSources;
  /**
   * Return the kind of the given source, or {@code null} if the kind is not known to this context.
   * @param source the source whose kind is to be returned
   * @return the kind of the given source
   * @see #computeKindOf(Source)
   */
  SourceKind getKindOf(Source source);
  /**
   * Return an array containing all of the sources known to this context that represent the defining
   * compilation unit of a library that can be run within a browser. The sources that are returned
   * represent libraries that have a 'main' method and are either referenced by an HTML file or
   * import, directly or indirectly, a client-only library. The contents of the array can be
   * incomplete.
   * @return the sources known to this context that represent the defining compilation unit of a
   * library that can be run within a browser
   */
  List<Source> get launchableClientLibrarySources;
  /**
   * Return an array containing all of the sources known to this context that represent the defining
   * compilation unit of a library that can be run outside of a browser. The contents of the array
   * can be incomplete.
   * @return the sources known to this context that represent the defining compilation unit of a
   * library that can be run outside of a browser
   */
  List<Source> get launchableServerLibrarySources;
  /**
   * Return the sources for the defining compilation units of any libraries of which the given
   * source is a part. The array will normally contain a single library because most Dart sources
   * are only included in a single library, but it is possible to have a part that is contained in
   * multiple identically named libraries. If the source represents the defining compilation unit of
   * a library, then the returned array will contain the given source as its only element. If the
   * source does not represent a Dart source or is not known to this context, the returned array
   * will be empty. The contents of the array can be incomplete.
   * @param source the source contained in the returned libraries
   * @return the sources for the libraries containing the given source
   */
  List<Source> getLibrariesContaining(Source source);
  /**
   * Return the element model corresponding to the library defined by the given source, or{@code null} if the element model does not currently exist or if the library cannot be analyzed
   * for some reason.
   * @param source the source defining the library whose element model is to be returned
   * @return the element model corresponding to the library defined by the given source
   */
  LibraryElement getLibraryElement(Source source);
  /**
   * Return an array containing all of the sources known to this context that represent the defining
   * compilation unit of a library. The contents of the array can be incomplete.
   * @return the sources known to this context that represent the defining compilation unit of a
   * library
   */
  List<Source> get librarySources;
  /**
   * Return the line information for the given source, or {@code null} if the line information is
   * not known. The line information is used to map offsets from the beginning of the source to line
   * and column pairs.
   * @param source the source whose line information is to be returned
   * @return the line information for the given source
   * @see #computeLineInfo(Source)
   */
  LineInfo getLineInfo(Source source);
  /**
   * Return the source factory used to create the sources that can be analyzed in this context.
   * @return the source factory used to create the sources that can be analyzed in this context
   */
  SourceFactory get sourceFactory;
  /**
   * Return {@code true} if the given source is known to be the defining compilation unit of a
   * library that can be run on a client (references 'dart:html', either directly or indirectly).
   * <p>
   * <b>Note:</b> In addition to the expected case of returning {@code false} if the source is known
   * to be a library that cannot be run on a client, this method will also return {@code false} if
   * the source is not known to be a library or if we do not know whether it can be run on a client.
   * @param librarySource the source being tested
   * @return {@code true} if the given source is known to be a library that can be run on a client
   */
  bool isClientLibrary(Source librarySource);
  /**
   * Return {@code true} if the given source is known to be the defining compilation unit of a
   * library that can be run on the server (does not reference 'dart:html', either directly or
   * indirectly).
   * <p>
   * <b>Note:</b> In addition to the expected case of returning {@code false} if the source is known
   * to be a library that cannot be run on the server, this method will also return {@code false} if
   * the source is not known to be a library or if we do not know whether it can be run on the
   * server.
   * @param librarySource the source being tested
   * @return {@code true} if the given source is known to be a library that can be run on the server
   */
  bool isServerLibrary(Source librarySource);
  /**
   * Add the sources contained in the specified context to this context's collection of sources.
   * This method is called when an existing context's pubspec has been removed, and the contained
   * sources should be reanalyzed as part of this context.
   * @param context the context being merged
   */
  void mergeContext(AnalysisContext context);
  /**
   * Parse a single source to produce an AST structure. The resulting AST structure may or may not
   * be resolved, and may have a slightly different structure depending upon whether it is resolved.
   * @param source the source to be parsed
   * @return the AST structure representing the content of the source
   * @throws AnalysisException if the analysis could not be performed
   */
  CompilationUnit parseCompilationUnit(Source source);
  /**
   * Parse a single HTML source to produce an AST structure. The resulting HTML AST structure may or
   * may not be resolved, and may have a slightly different structure depending upon whether it is
   * resolved.
   * @param source the HTML source to be parsed
   * @return the parse result (not {@code null})
   * @throws AnalysisException if the analysis could not be performed
   */
  HtmlUnit parseHtmlUnit(Source source);
  /**
   * Perform the next unit of work required to keep the analysis results up-to-date and return
   * information about the consequent changes to the analysis results. If there were no results the
   * returned array will be empty. If there are no more units of work required, then this method
   * returns {@code null}. This method can be long running.
   * @return an array containing notices of changes to the analysis results
   */
  List<ChangeNotice> performAnalysisTask();
  /**
   * Parse and resolve a single source within the given context to produce a fully resolved AST.
   * @param unitSource the source to be parsed and resolved
   * @param library the library containing the source to be resolved
   * @return the result of resolving the AST structure representing the content of the source in the
   * context of the given library
   * @throws AnalysisException if the analysis could not be performed
   */
  CompilationUnit resolveCompilationUnit(Source unitSource, LibraryElement library);
  /**
   * Parse and resolve a single source within the given context to produce a fully resolved AST.
   * @param unitSource the source to be parsed and resolved
   * @param librarySource the source of the defining compilation unit of the library containing the
   * source to be resolved
   * @return the result of resolving the AST structure representing the content of the source in the
   * context of the given library
   * @throws AnalysisException if the analysis could not be performed
   */
  CompilationUnit resolveCompilationUnit2(Source unitSource, Source librarySource);
  /**
   * Parse and resolve a single source within the given context to produce a fully resolved AST.
   * @param htmlSource the source to be parsed and resolved
   * @return the result of resolving the AST structure representing the content of the source
   * @throws AnalysisException if the analysis could not be performed
   */
  HtmlUnit resolveHtmlUnit(Source htmlSource);
  /**
   * Set the contents of the given source to the given contents and mark the source as having
   * changed. This has the effect of overriding the default contents of the source. If the contents
   * are {@code null} the override is removed so that the default contents will be returned.
   * @param source the source whose contents are being overridden
   * @param contents the new contents of the source
   */
  void setContents(Source source, String contents);
  /**
   * Set the source factory used to create the sources that can be analyzed in this context to the
   * given source factory. Clients can safely assume that all analysis results have been
   * invalidated.
   * @param factory the source factory used to create the sources that can be analyzed in this
   * context
   */
  void set sourceFactory(SourceFactory factory);
  /**
   * Given a collection of sources with content that has changed, return an {@link Iterable}identifying the sources that need to be resolved.
   * @param changedSources an array of sources (not {@code null}, contains no {@code null}s)
   * @return An iterable returning the sources to be resolved
   */
  Iterable<Source> sourcesToResolve(List<Source> changedSources);
}
/**
 * Instances of the class {@code AnalysisException} represent an exception that occurred during the
 * analysis of one or more sources.
 * @coverage dart.engine
 */
class AnalysisException extends JavaException {
  /**
   * Initialize a newly created exception.
   */
  AnalysisException() : super() {
    _jtd_constructor_124_impl();
  }
  _jtd_constructor_124_impl() {
  }
  /**
   * Initialize a newly created exception to have the given message.
   * @param message the message associated with the exception
   */
  AnalysisException.con1(String message) : super(message) {
    _jtd_constructor_125_impl(message);
  }
  _jtd_constructor_125_impl(String message) {
  }
  /**
   * Initialize a newly created exception to have the given message and cause.
   * @param message the message associated with the exception
   * @param cause the underlying exception that caused this exception
   */
  AnalysisException.con2(String message, Exception cause) : super(message, cause) {
    _jtd_constructor_126_impl(message, cause);
  }
  _jtd_constructor_126_impl(String message, Exception cause) {
  }
  /**
   * Initialize a newly created exception to have the given cause.
   * @param cause the underlying exception that caused this exception
   */
  AnalysisException.con3(Exception cause) : super.withCause(cause) {
    _jtd_constructor_127_impl(cause);
  }
  _jtd_constructor_127_impl(Exception cause) {
  }
}
/**
 * The interface {@code ChangeNotice} defines the behavior of objects that represent a change to the
 * analysis results associated with a given source.
 * @coverage dart.engine
 */
abstract class ChangeNotice {
  /**
   * Return the fully resolved AST that changed as a result of the analysis, or {@code null} if the
   * AST was not changed.
   * @return the fully resolved AST that changed as a result of the analysis
   */
  CompilationUnit get compilationUnit;
  /**
   * Return the errors that changed as a result of the analysis, or {@code null} if errors were not
   * changed.
   * @return the errors that changed as a result of the analysis
   */
  List<AnalysisError> get errors;
  /**
   * Return the line information associated with the source, or {@code null} if errors were not
   * changed.
   * @return the line information associated with the source
   */
  LineInfo get lineInfo;
  /**
   * Return the source for which the result is being reported.
   * @return the source for which the result is being reported
   */
  Source get source;
}
/**
 * Instances of the class {@code ChangeSet} indicate what sources have been added, changed, or
 * removed.
 * @coverage dart.engine
 */
class ChangeSet {
  /**
   * A list containing the sources that have been added.
   */
  List<Source> _added2 = new List<Source>();
  /**
   * A list containing the sources that have been changed.
   */
  List<Source> _changed2 = new List<Source>();
  /**
   * A list containing the sources that have been removed.
   */
  List<Source> _removed2 = new List<Source>();
  /**
   * A list containing the source containers specifying additional sources that have been removed.
   */
  List<SourceContainer> _removedContainers = new List<SourceContainer>();
  /**
   * Initialize a newly created change set to be empty.
   */
  ChangeSet() : super() {
  }
  /**
   * Record that the specified source has been added and that it's content is the default contents
   * of the source.
   * @param source the source that was added
   */
  void added(Source source) {
    _added2.add(source);
  }
  /**
   * Record that the specified source has been changed and that it's content is the default contents
   * of the source.
   * @param source the source that was changed
   */
  void changed(Source source) {
    _changed2.add(source);
  }
  /**
   * Return a collection of the sources that have been added.
   * @return a collection of the sources that have been added
   */
  List<Source> get added3 => _added2;
  /**
   * Return a collection of sources that have been changed.
   * @return a collection of sources that have been changed
   */
  List<Source> get changed3 => _changed2;
  /**
   * Return a list containing the sources that were removed.
   * @return a list containing the sources that were removed
   */
  List<Source> get removed => _removed2;
  /**
   * Return a list containing the source containers that were removed.
   * @return a list containing the source containers that were removed
   */
  List<SourceContainer> get removedContainers => _removedContainers;
  /**
   * Return {@code true} if this change set does not contain any changes.
   * @return {@code true} if this change set does not contain any changes
   */
  bool isEmpty() => _added2.isEmpty && _changed2.isEmpty && _removed2.isEmpty && _removedContainers.isEmpty;
  /**
   * Record that the specified source has been removed.
   * @param source the source that was removed
   */
  void removed3(Source source) {
    if (source != null) {
      _removed2.add(source);
    }
  }
  /**
   * Record that the specified source container has been removed.
   * @param container the source container that was removed
   */
  void removedContainer(SourceContainer container) {
    if (container != null) {
      _removedContainers.add(container);
    }
  }
}
/**
 * Instances of the class {@code AnalysisContextImpl} implement an {@link AnalysisContext analysis
 * context}.
 * @coverage dart.engine
 */
class AnalysisContextImpl implements AnalysisContext {
  /**
   * The source factory used to create the sources that can be analyzed in this context.
   */
  SourceFactory _sourceFactory;
  /**
   * A table mapping the sources known to the context to the information known about the source.
   */
  Map<Source, SourceInfo> _sourceMap = new Map<Source, SourceInfo>();
  /**
   * A table mapping sources to the change notices that are waiting to be returned related to that
   * source.
   */
  Map<Source, ChangeNoticeImpl> _pendingNotices = new Map<Source, ChangeNoticeImpl>();
  /**
   * The object used to synchronize access to all of the caches.
   */
  Object _cacheLock = new Object();
  /**
   * The name of the 'src' attribute in a HTML tag.
   */
  static String _ATTRIBUTE_SRC = "src";
  /**
   * The name of the 'script' tag in an HTML file.
   */
  static String _TAG_SCRIPT = "script";
  /**
   * Initialize a newly created analysis context.
   */
  AnalysisContextImpl() : super() {
  }
  void applyChanges(ChangeSet changeSet) {
    if (changeSet.isEmpty()) {
      return;
    }
    {
      List<Source> removedSources = new List<Source>.from(changeSet.removed);
      for (SourceContainer container in changeSet.removedContainers) {
        addSourcesInContainer(removedSources, container);
      }
      for (Source source in changeSet.added3) {
        sourceAvailable(source);
      }
      for (Source source in changeSet.changed3) {
        sourceChanged(source);
      }
      for (Source source in removedSources) {
        sourceRemoved(source);
      }
    }
  }
  List<AnalysisError> computeErrors(Source source) {
    {
      CompilationUnitInfo info = getCompilationUnitInfo(source);
      if (info == null) {
        return AnalysisError.NO_ERRORS;
      }
      if (info.hasInvalidParseErrors()) {
        parseCompilationUnit(source);
      }
      if (info.hasInvalidResolutionErrors()) {
      }
      return info.allErrors;
    }
  }
  HtmlElement computeHtmlElement(Source source) {
    if (!AnalysisEngine.isHtmlFileName(source.shortName)) {
      return null;
    }
    {
      HtmlUnitInfo htmlUnitInfo = getHtmlUnitInfo(source);
      if (htmlUnitInfo == null) {
        return null;
      }
      HtmlElement element24 = htmlUnitInfo.element;
      if (element24 == null) {
        HtmlUnit unit = htmlUnitInfo.resolvedUnit;
        if (unit == null) {
          unit = htmlUnitInfo.parsedUnit;
          if (unit == null) {
            unit = parseHtmlUnit(source);
          }
        }
        HtmlUnitBuilder builder = new HtmlUnitBuilder(this);
        element24 = builder.buildHtmlElement2(source, unit);
        htmlUnitInfo.resolvedUnit = unit;
        htmlUnitInfo.element = element24;
      }
      return element24;
    }
  }
  SourceKind computeKindOf(Source source) {
    {
      SourceInfo sourceInfo = getSourceInfo(source);
      if (sourceInfo == null) {
        return SourceKind.UNKNOWN;
      } else if (sourceInfo is DartInfo) {
        sourceInfo = internalComputeKindOf(source, sourceInfo);
      }
      return sourceInfo.kind;
    }
  }
  LibraryElement computeLibraryElement(Source source) {
    if (!AnalysisEngine.isDartFileName(source.shortName)) {
      return null;
    }
    {
      LibraryInfo libraryInfo = getLibraryInfo(source);
      if (libraryInfo == null) {
        return null;
      }
      LibraryElement element25 = libraryInfo.element;
      if (element25 == null) {
        if (computeKindOf(source) != SourceKind.LIBRARY) {
          return null;
        }
        LibraryResolver resolver = new LibraryResolver.con1(this);
        try {
          element25 = resolver.resolveLibrary(source, true);
          if (element25 != null) {
            libraryInfo.element = element25;
          }
        } on AnalysisException catch (exception) {
          AnalysisEngine.instance.logger.logError2("Could not resolve the library ${source.fullName}", exception);
        }
      }
      return element25;
    }
  }
  LineInfo computeLineInfo(Source source) {
    {
      SourceInfo sourceInfo = getSourceInfo(source);
      if (sourceInfo == null) {
        return null;
      }
      LineInfo lineInfo4 = sourceInfo.lineInfo;
      if (lineInfo4 == null) {
        if (sourceInfo is DartInfo) {
          sourceInfo = internalComputeKindOf(source, sourceInfo);
        }
        if (sourceInfo is HtmlUnitInfo) {
          parseHtmlUnit(source);
          lineInfo4 = sourceInfo.lineInfo;
        } else if (sourceInfo is CompilationUnitInfo) {
          parseCompilationUnit(source);
          lineInfo4 = sourceInfo.lineInfo;
        }
      }
      return lineInfo4;
    }
  }
  AnalysisContext extractContext(SourceContainer container) {
    AnalysisContextImpl newContext = AnalysisEngine.instance.createAnalysisContext() as AnalysisContextImpl;
    List<Source> sourcesToRemove = new List<Source>();
    {
      for (MapEntry<Source, SourceInfo> entry in getMapEntrySet(_sourceMap)) {
        Source source = entry.getKey();
        if (container.contains(source)) {
          sourcesToRemove.add(source);
          newContext._sourceMap[source] = entry.getValue().copy();
        }
      }
    }
    return newContext;
  }
  Element getElement(ElementLocation location) {
    List<String> components2 = ((location as ElementLocationImpl)).components;
    ElementImpl element;
    {
      Source librarySource = _sourceFactory.fromEncoding(components2[0]);
      try {
        element = computeLibraryElement(librarySource) as ElementImpl;
      } on AnalysisException catch (exception) {
        return null;
      }
    }
    for (int i = 1; i < components2.length; i++) {
      if (element == null) {
        return null;
      }
      element = element.getChild(components2[i]);
    }
    return element;
  }
  List<AnalysisError> getErrors(Source source) {
    {
      SourceInfo info = getSourceInfo(source);
      if (info is CompilationUnitInfo) {
        return ((info as CompilationUnitInfo)).allErrors;
      }
      return AnalysisError.NO_ERRORS;
    }
  }
  HtmlElement getHtmlElement(Source source) {
    {
      SourceInfo info = getSourceInfo(source);
      if (info is HtmlUnitInfo) {
        return ((info as HtmlUnitInfo)).element;
      }
      return null;
    }
  }
  List<Source> getHtmlFilesReferencing(Source source) {
    {
      SourceInfo info = getSourceInfo(source);
      if (info is LibraryInfo) {
        return ((info as LibraryInfo)).htmlSources;
      } else if (info is CompilationUnitInfo) {
        List<Source> sources = new List<Source>();
        for (Source librarySource in ((info as CompilationUnitInfo)).librarySources) {
          LibraryInfo libraryInfo = getLibraryInfo(librarySource);
          for (Source htmlSource in libraryInfo.htmlSources) {
            sources.add(htmlSource);
          }
        }
        if (!sources.isEmpty) {
          return new List.from(sources);
        }
      }
      return Source.EMPTY_ARRAY;
    }
  }
  List<Source> get htmlSources => getSources(SourceKind.HTML);
  SourceKind getKindOf(Source source) {
    {
      SourceInfo sourceInfo = getSourceInfo(source);
      if (sourceInfo == null) {
        return SourceKind.UNKNOWN;
      }
      return sourceInfo.kind;
    }
  }
  List<Source> get launchableClientLibrarySources {
    List<Source> sources = new List<Source>();
    {
      for (MapEntry<Source, SourceInfo> entry in getMapEntrySet(_sourceMap)) {
        Source source = entry.getKey();
        SourceInfo info = entry.getValue();
        if (identical(info.kind, SourceKind.LIBRARY) && !source.isInSystemLibrary()) {
          sources.add(source);
        }
      }
    }
    return new List.from(sources);
  }
  List<Source> get launchableServerLibrarySources {
    List<Source> sources = new List<Source>();
    {
      for (MapEntry<Source, SourceInfo> entry in getMapEntrySet(_sourceMap)) {
        Source source = entry.getKey();
        SourceInfo info = entry.getValue();
        if (identical(info.kind, SourceKind.LIBRARY) && !source.isInSystemLibrary()) {
          sources.add(source);
        }
      }
    }
    return new List.from(sources);
  }
  List<Source> getLibrariesContaining(Source source) {
    {
      SourceInfo info = getSourceInfo(source);
      if (info is CompilationUnitInfo) {
        return ((info as CompilationUnitInfo)).librarySources;
      }
      return Source.EMPTY_ARRAY;
    }
  }
  LibraryElement getLibraryElement(Source source) {
    {
      SourceInfo info = getSourceInfo(source);
      if (info is LibraryInfo) {
        return ((info as LibraryInfo)).element;
      }
      return null;
    }
  }
  List<Source> get librarySources => getSources(SourceKind.LIBRARY);
  LineInfo getLineInfo(Source source) {
    {
      SourceInfo info = getSourceInfo(source);
      if (info != null) {
        return info.lineInfo;
      }
      return null;
    }
  }
  /**
   * Return a namespace containing mappings for all of the public names defined by the given
   * library.
   * @param library the library whose public namespace is to be returned
   * @return the public namespace of the given library
   */
  Namespace getPublicNamespace(LibraryElement library) {
    Source source8 = library.definingCompilationUnit.source;
    {
      LibraryInfo libraryInfo = getLibraryInfo(source8);
      if (libraryInfo == null) {
        return null;
      }
      Namespace namespace = libraryInfo.publicNamespace;
      if (namespace == null) {
        NamespaceBuilder builder = new NamespaceBuilder();
        namespace = builder.createPublicNamespace(library);
        libraryInfo.publicNamespace = namespace;
      }
      return namespace;
    }
  }
  /**
   * Return a namespace containing mappings for all of the public names defined by the library
   * defined by the given source.
   * @param source the source defining the library whose public namespace is to be returned
   * @return the public namespace corresponding to the library defined by the given source
   * @throws AnalysisException if the public namespace could not be computed
   */
  Namespace getPublicNamespace2(Source source) {
    {
      LibraryInfo libraryInfo = getLibraryInfo(source);
      if (libraryInfo == null) {
        return null;
      }
      Namespace namespace = libraryInfo.publicNamespace;
      if (namespace == null) {
        LibraryElement library = computeLibraryElement(source);
        if (library == null) {
          return null;
        }
        NamespaceBuilder builder = new NamespaceBuilder();
        namespace = builder.createPublicNamespace(library);
        libraryInfo.publicNamespace = namespace;
      }
      return namespace;
    }
  }
  SourceFactory get sourceFactory => _sourceFactory;
  bool isClientLibrary(Source librarySource) {
    SourceInfo sourceInfo = getSourceInfo(librarySource);
    if (sourceInfo is LibraryInfo) {
      LibraryInfo libraryInfo = sourceInfo as LibraryInfo;
      if (libraryInfo.hasInvalidLaunchable() || libraryInfo.hasInvalidClientServer()) {
        return false;
      }
      return libraryInfo.isLaunchable() && libraryInfo.isClient();
    }
    return false;
  }
  bool isServerLibrary(Source librarySource) {
    SourceInfo sourceInfo = getSourceInfo(librarySource);
    if (sourceInfo is LibraryInfo) {
      LibraryInfo libraryInfo = sourceInfo as LibraryInfo;
      if (libraryInfo.hasInvalidLaunchable() || libraryInfo.hasInvalidClientServer()) {
        return false;
      }
      return libraryInfo.isLaunchable() && libraryInfo.isServer();
    }
    return false;
  }
  void mergeContext(AnalysisContext context) {
    {
      for (MapEntry<Source, SourceInfo> entry in getMapEntrySet(((context as AnalysisContextImpl))._sourceMap)) {
        Source newSource = entry.getKey();
        SourceInfo existingInfo = getSourceInfo(newSource);
        if (existingInfo == null) {
          _sourceMap[newSource] = entry.getValue().copy();
        } else {
        }
      }
    }
  }
  CompilationUnit parseCompilationUnit(Source source) {
    {
      CompilationUnitInfo compilationUnitInfo = getCompilationUnitInfo(source);
      if (compilationUnitInfo == null) {
        return null;
      }
      CompilationUnit unit = compilationUnitInfo.resolvedCompilationUnit;
      if (unit == null) {
        unit = compilationUnitInfo.parsedCompilationUnit;
        if (unit == null) {
          RecordingErrorListener errorListener = new RecordingErrorListener();
          AnalysisContextImpl_ScanResult scanResult = internalScan(source, errorListener);
          Parser parser = new Parser(source, errorListener);
          unit = parser.parseCompilationUnit(scanResult._token);
          LineInfo lineInfo = new LineInfo(scanResult._lineStarts);
          List<AnalysisError> errors = errorListener.getErrors2(source);
          unit.parsingErrors = errors;
          unit.lineInfo = lineInfo;
          compilationUnitInfo.lineInfo = lineInfo;
          compilationUnitInfo.parsedCompilationUnit = unit;
          compilationUnitInfo.parseErrors = errors;
        }
      }
      return unit;
    }
  }
  HtmlUnit parseHtmlUnit(Source source) {
    {
      HtmlUnitInfo htmlUnitInfo = getHtmlUnitInfo(source);
      if (htmlUnitInfo == null) {
        return null;
      }
      HtmlUnit unit = htmlUnitInfo.resolvedUnit;
      if (unit == null) {
        unit = htmlUnitInfo.parsedUnit;
        if (unit == null) {
          HtmlParseResult result = new HtmlParser(source).parse(scanHtml(source));
          unit = result.htmlUnit;
          htmlUnitInfo.lineInfo = new LineInfo(result.lineStarts);
          htmlUnitInfo.parsedUnit = unit;
          for (SourceInfo sourceInfo in _sourceMap.values) {
            if (sourceInfo is LibraryInfo) {
              ((sourceInfo as LibraryInfo)).removeHtmlSource(source);
            }
          }
          for (Source librarySource in getLibrarySources2(source, unit)) {
            LibraryInfo libraryInfo = getLibraryInfo(librarySource);
            if (libraryInfo != null) {
              libraryInfo.addHtmlSource(source);
            }
          }
        }
      }
      return unit;
    }
  }
  List<ChangeNotice> performAnalysisTask() {
    {
      if (!performSingleAnalysisTask() && _pendingNotices.isEmpty) {
        return null;
      }
      if (_pendingNotices.isEmpty) {
        return ChangeNoticeImpl.EMPTY_ARRAY;
      }
      List<ChangeNotice> notices = new List.from(_pendingNotices.values);
      _pendingNotices.clear();
      return notices;
    }
  }
  /**
   * Given a table mapping the source for the libraries represented by the corresponding elements to
   * the elements representing the libraries, record those mappings.
   * @param elementMap a table mapping the source for the libraries represented by the elements to
   * the elements representing the libraries
   */
  void recordLibraryElements(Map<Source, LibraryElement> elementMap) {
    Source htmlSource = _sourceFactory.forUri("dart:html");
    {
      for (MapEntry<Source, LibraryElement> entry in getMapEntrySet(elementMap)) {
        LibraryElement library = entry.getValue();
        LibraryInfo libraryInfo = getLibraryInfo(entry.getKey());
        if (libraryInfo != null) {
          libraryInfo.element = library;
          libraryInfo.launchable = library.entryPoint != null;
          libraryInfo.client = isClient(library, htmlSource, new Set<LibraryElement>());
        }
        Source librarySource = library.source;
        if (librarySource != null) {
          for (SourceInfo info in _sourceMap.values) {
            if (info is CompilationUnitInfo) {
              ((info as CompilationUnitInfo)).removeLibrarySource(librarySource);
            }
          }
          if (libraryInfo != null) {
            libraryInfo.addLibrarySource(librarySource);
          }
          for (CompilationUnitElement part in library.parts) {
            Source partSource = part.source;
            CompilationUnitInfo partInfo = partSource == null ? null : getCompilationUnitInfo(partSource);
            if (partInfo != null) {
              partInfo.addLibrarySource(librarySource);
            }
          }
        }
      }
    }
  }
  /**
   * Give the resolution errors and line info associated with the given source, add the information
   * to the cache.
   * @param source the source with which the information is associated
   * @param errors the resolution errors associated with the source
   * @param lineInfo the line information associated with the source
   */
  void recordResolutionErrors(Source source, List<AnalysisError> errors, LineInfo lineInfo5) {
    {
      CompilationUnitInfo compilationUnitInfo = getCompilationUnitInfo(source);
      if (compilationUnitInfo != null) {
        compilationUnitInfo.lineInfo = lineInfo5;
        compilationUnitInfo.resolutionErrors = errors;
      }
      getNotice(source).setErrors(compilationUnitInfo.allErrors, lineInfo5);
    }
  }
  /**
   * Give the resolved compilation unit associated with the given source, add the unit to the cache.
   * @param source the source with which the unit is associated
   * @param unit the compilation unit associated with the source
   */
  void recordResolvedCompilationUnit(Source source, CompilationUnit unit) {
    {
      CompilationUnitInfo compilationUnitInfo = getCompilationUnitInfo(source);
      if (compilationUnitInfo != null) {
        compilationUnitInfo.resolvedCompilationUnit = unit;
        getNotice(source).compilationUnit = unit;
      }
    }
  }
  CompilationUnit resolveCompilationUnit(Source source15, LibraryElement library) {
    if (library == null) {
      return null;
    }
    return resolveCompilationUnit2(source15, library.source);
  }
  CompilationUnit resolveCompilationUnit2(Source unitSource, Source librarySource) {
    {
      CompilationUnitInfo compilationUnitInfo = getCompilationUnitInfo(unitSource);
      if (compilationUnitInfo == null) {
        return null;
      }
      CompilationUnit unit = compilationUnitInfo.resolvedCompilationUnit;
      if (unit == null) {
        computeLibraryElement(librarySource);
        unit = compilationUnitInfo.resolvedCompilationUnit;
      }
      return unit;
    }
  }
  HtmlUnit resolveHtmlUnit(Source unitSource) {
    {
      HtmlUnitInfo htmlUnitInfo = getHtmlUnitInfo(unitSource);
      if (htmlUnitInfo == null) {
        return null;
      }
      HtmlUnit unit = htmlUnitInfo.resolvedUnit;
      if (unit == null) {
        computeHtmlElement(unitSource);
        unit = htmlUnitInfo.resolvedUnit;
      }
      return unit;
    }
  }
  void setContents(Source source, String contents) {
    {
      _sourceFactory.setContents(source, contents);
      sourceChanged(source);
    }
  }
  void set sourceFactory(SourceFactory factory) {
    if (identical(_sourceFactory, factory)) {
      return;
    } else if (factory.context != null) {
      throw new IllegalStateException("Source factories cannot be shared between contexts");
    }
    {
      if (_sourceFactory != null) {
        _sourceFactory.context = null;
      }
      factory.context = this;
      _sourceFactory = factory;
      for (SourceInfo sourceInfo in _sourceMap.values) {
        if (sourceInfo is HtmlUnitInfo) {
          ((sourceInfo as HtmlUnitInfo)).invalidateResolvedUnit();
        } else if (sourceInfo is CompilationUnitInfo) {
          CompilationUnitInfo compilationUnitInfo = sourceInfo as CompilationUnitInfo;
          compilationUnitInfo.invalidateResolvedUnit();
          compilationUnitInfo.invalidateResolutionErrors();
          if (sourceInfo is LibraryInfo) {
            LibraryInfo libraryInfo = sourceInfo as LibraryInfo;
            libraryInfo.invalidateElement();
            libraryInfo.invalidatePublicNamespace();
            libraryInfo.invalidateLaunchable();
            libraryInfo.invalidateClientServer();
          }
        }
      }
    }
  }
  Iterable<Source> sourcesToResolve(List<Source> changedSources) {
    List<Source> librarySources = new List<Source>();
    for (Source source in changedSources) {
      if (identical(computeKindOf(source), SourceKind.LIBRARY)) {
        librarySources.add(source);
      }
    }
    return librarySources;
  }
  /**
   * Add all of the sources contained in the given source container to the given list of sources.
   * <p>
   * Note: This method must only be invoked while we are synchronized on {@link #cacheLock}.
   * @param sources the list to which sources are to be added
   * @param container the source container containing the sources to be added to the list
   */
  void addSourcesInContainer(List<Source> sources, SourceContainer container) {
    for (Source source in _sourceMap.keys.toSet()) {
      if (container.contains(source)) {
        sources.add(source);
      }
    }
  }
  /**
   * Create a source information object suitable for the given source. Return the source information
   * object that was created, or {@code null} if the source should not be tracked by this context.
   * @param source the source for which an information object is being created
   * @return the source information object that was created
   */
  SourceInfo createSourceInfo(Source source) {
    String name = source.shortName;
    if (AnalysisEngine.isHtmlFileName(name)) {
      HtmlUnitInfo info = new HtmlUnitInfo();
      _sourceMap[source] = info;
      return info;
    } else if (AnalysisEngine.isDartFileName(name)) {
      DartInfo info = DartInfo.instance;
      _sourceMap[source] = info;
      return info;
    }
    return null;
  }
  /**
   * Return the compilation unit information associated with the given source, or {@code null} if
   * the source is not known to this context. This method should be used to access the compilation
   * unit information rather than accessing the compilation unit map directly because sources in the
   * SDK are implicitly part of every analysis context and are therefore only added to the map when
   * first accessed.
   * <p>
   * <b>Note:</b> This method must only be invoked while we are synchronized on {@link #cacheLock}.
   * @param source the source for which information is being sought
   * @return the compilation unit information associated with the given source
   */
  CompilationUnitInfo getCompilationUnitInfo(Source source) {
    SourceInfo sourceInfo = getSourceInfo(source);
    if (sourceInfo == null) {
      sourceInfo = new CompilationUnitInfo();
      _sourceMap[source] = sourceInfo;
      return sourceInfo as CompilationUnitInfo;
    } else if (sourceInfo is CompilationUnitInfo) {
      return sourceInfo as CompilationUnitInfo;
    } else if (sourceInfo is DartInfo) {
      sourceInfo = internalComputeKindOf(source, sourceInfo);
      if (sourceInfo is CompilationUnitInfo) {
        return sourceInfo as CompilationUnitInfo;
      }
    }
    return null;
  }
  /**
   * Return the HTML unit information associated with the given source, or {@code null} if the
   * source is not known to this context. This method should be used to access the HTML unit
   * information rather than accessing the HTML unit map directly because sources in the SDK are
   * implicitly part of every analysis context and are therefore only added to the map when first
   * accessed.
   * <p>
   * <b>Note:</b> This method must only be invoked while we are synchronized on {@link #cacheLock}.
   * @param source the source for which information is being sought
   * @return the HTML unit information associated with the given source
   */
  HtmlUnitInfo getHtmlUnitInfo(Source source) {
    SourceInfo sourceInfo = getSourceInfo(source);
    if (sourceInfo == null) {
      sourceInfo = new HtmlUnitInfo();
      _sourceMap[source] = sourceInfo;
      return sourceInfo as HtmlUnitInfo;
    } else if (sourceInfo is HtmlUnitInfo) {
      return sourceInfo as HtmlUnitInfo;
    }
    return null;
  }
  /**
   * Return the library information associated with the given source, or {@code null} if the source
   * is not known to this context. This method should be used to access the library information
   * rather than accessing the library map directly because sources in the SDK are implicitly part
   * of every analysis context and are therefore only added to the map when first accessed.
   * <p>
   * <b>Note:</b> This method must only be invoked while we are synchronized on {@link #cacheLock}.
   * @param source the source for which information is being sought
   * @return the library information associated with the given source
   */
  LibraryInfo getLibraryInfo(Source source) {
    SourceInfo sourceInfo = getSourceInfo(source);
    if (sourceInfo == null) {
      sourceInfo = new LibraryInfo();
      _sourceMap[source] = sourceInfo;
      return sourceInfo as LibraryInfo;
    } else if (sourceInfo is LibraryInfo) {
      return sourceInfo as LibraryInfo;
    } else if (sourceInfo is DartInfo) {
      sourceInfo = internalComputeKindOf(source, sourceInfo);
      if (sourceInfo is LibraryInfo) {
        return sourceInfo as LibraryInfo;
      }
    }
    return null;
  }
  /**
   * Return the sources of libraries that are referenced in the specified HTML file.
   * @param htmlSource the source of the HTML file being analyzed
   * @param htmlUnit the AST for the HTML file being analyzed
   * @return the sources of libraries that are referenced in the HTML file
   */
  List<Source> getLibrarySources2(Source htmlSource, HtmlUnit htmlUnit) {
    List<Source> libraries = new List<Source>();
    htmlUnit.accept(new SimpleXmlVisitor_3(htmlSource, libraries));
    return libraries;
  }
  /**
   * Return a change notice for the given source, creating one if one does not already exist.
   * @param source the source for which changes are being reported
   * @return a change notice for the given source
   */
  ChangeNoticeImpl getNotice(Source source) {
    ChangeNoticeImpl notice = _pendingNotices[source];
    if (notice == null) {
      notice = new ChangeNoticeImpl(source);
      _pendingNotices[source] = notice;
    }
    return notice;
  }
  /**
   * Return the source information associated with the given source, or {@code null} if the source
   * is not known to this context. This method should be used to access the source information
   * rather than accessing the source map directly because sources in the SDK are implicitly part of
   * every analysis context and are therefore only added to the map when first accessed.
   * <p>
   * <b>Note:</b> This method must only be invoked while we are synchronized on {@link #cacheLock}.
   * @param source the source for which information is being sought
   * @return the source information associated with the given source
   */
  SourceInfo getSourceInfo(Source source) {
    SourceInfo sourceInfo = _sourceMap[source];
    if (sourceInfo == null) {
      sourceInfo = createSourceInfo(source);
    }
    return sourceInfo;
  }
  /**
   * Return an array containing all of the sources known to this context that have the given kind.
   * @param kind the kind of sources to be returned
   * @return all of the sources known to this context that have the given kind
   */
  List<Source> getSources(SourceKind kind3) {
    List<Source> sources = new List<Source>();
    {
      for (MapEntry<Source, SourceInfo> entry in getMapEntrySet(_sourceMap)) {
        if (identical(entry.getValue().kind, kind3)) {
          sources.add(entry.getKey());
        }
      }
    }
    return new List.from(sources);
  }
  /**
   * Return {@code true} if the given compilation unit has a part-of directive.
   * @param unit the compilation unit being tested
   * @return {@code true} if the compilation unit has a part-of directive
   */
  bool hasPartOfDirective(CompilationUnit unit) {
    for (Directive directive in unit.directives) {
      if (directive is PartOfDirective) {
        return true;
      }
    }
    return false;
  }
  SourceInfo internalComputeKindOf(Source source, SourceInfo info) {
    try {
      RecordingErrorListener errorListener = new RecordingErrorListener();
      AnalysisContextImpl_ScanResult scanResult = internalScan(source, errorListener);
      Parser parser = new Parser(source, errorListener);
      CompilationUnit unit = parser.parseCompilationUnit(scanResult._token);
      LineInfo lineInfo = new LineInfo(scanResult._lineStarts);
      List<AnalysisError> errors = errorListener.getErrors2(source);
      unit.parsingErrors = errors;
      unit.lineInfo = lineInfo;
      CompilationUnitInfo sourceInfo;
      if (hasPartOfDirective(unit)) {
        sourceInfo = new CompilationUnitInfo();
      } else {
        sourceInfo = new LibraryInfo();
      }
      sourceInfo.lineInfo = lineInfo;
      sourceInfo.parsedCompilationUnit = unit;
      sourceInfo.parseErrors = errors;
      _sourceMap[source] = sourceInfo;
      return sourceInfo;
    } on AnalysisException catch (exception) {
      return info;
    }
  }
  AnalysisContextImpl_ScanResult internalScan(Source source, AnalysisErrorListener errorListener) {
    AnalysisContextImpl_ScanResult result = new AnalysisContextImpl_ScanResult();
    Source_ContentReceiver receiver = new Source_ContentReceiver_4(source, errorListener, result);
    try {
      source.getContents(receiver);
    } catch (exception) {
      throw new AnalysisException.con3(exception);
    }
    return result;
  }
  /**
   * Return {@code true} if this library is, or depends on, dart:html.
   * @param library the library being tested
   * @param visitedLibraries a collection of the libraries that have been visited, used to prevent
   * infinite recursion
   * @return {@code true} if this library is, or depends on, dart:html
   */
  bool isClient(LibraryElement library, Source htmlSource, Set<LibraryElement> visitedLibraries) {
    if (visitedLibraries.contains(library)) {
      return false;
    }
    if (library.source == htmlSource) {
      return true;
    }
    javaSetAdd(visitedLibraries, library);
    for (LibraryElement imported in library.importedLibraries) {
      if (isClient(imported, htmlSource, visitedLibraries)) {
        return true;
      }
    }
    for (LibraryElement exported in library.exportedLibraries) {
      if (isClient(exported, htmlSource, visitedLibraries)) {
        return true;
      }
    }
    return false;
  }
  /**
   * Perform a single analysis task.
   * <p>
   * <b>Note:</b> This method must only be invoked while we are synchronized on {@link #cacheLock}.
   * @return {@code true} if work was done, implying that there might be more work to be done
   */
  bool performSingleAnalysisTask() {
    for (MapEntry<Source, SourceInfo> entry in getMapEntrySet(_sourceMap)) {
      SourceInfo sourceInfo = entry.getValue();
      if (identical(sourceInfo, DartInfo.instance) || sourceInfo.kind == null) {
        internalComputeKindOf(entry.getKey(), sourceInfo);
        return true;
      }
    }
    for (MapEntry<Source, SourceInfo> entry in getMapEntrySet(_sourceMap)) {
      SourceInfo sourceInfo = entry.getValue();
      if (sourceInfo is CompilationUnitInfo) {
        CompilationUnitInfo unitInfo = sourceInfo as CompilationUnitInfo;
        if (unitInfo.hasInvalidParsedUnit()) {
          try {
            parseCompilationUnit(entry.getKey());
          } on AnalysisException catch (exception) {
            unitInfo.parsedCompilationUnit = null;
            AnalysisEngine.instance.logger.logError2("Could not parse ${entry.getKey().fullName}", exception);
          }
          return true;
        }
      } else if (sourceInfo is HtmlUnitInfo) {
        HtmlUnitInfo unitInfo = sourceInfo as HtmlUnitInfo;
        if (unitInfo.hasInvalidParsedUnit()) {
          try {
            parseHtmlUnit(entry.getKey());
          } on AnalysisException catch (exception) {
            unitInfo.parsedUnit = null;
            AnalysisEngine.instance.logger.logError2("Could not parse ${entry.getKey().fullName}", exception);
          }
          return true;
        }
      }
    }
    for (MapEntry<Source, SourceInfo> entry in getMapEntrySet(_sourceMap)) {
      SourceInfo sourceInfo = entry.getValue();
      if (sourceInfo is LibraryInfo) {
        LibraryInfo libraryInfo = sourceInfo as LibraryInfo;
        if (libraryInfo.hasInvalidElement()) {
          try {
            computeLibraryElement(entry.getKey());
          } on AnalysisException catch (exception) {
            libraryInfo.element = null;
            AnalysisEngine.instance.logger.logError2("Could not compute the library element for ${entry.getKey().fullName}", exception);
          }
          return true;
        }
      }
    }
    return false;
  }
  HtmlScanResult scanHtml(Source source) {
    HtmlScanner scanner = new HtmlScanner(source);
    try {
      source.getContents(scanner);
    } catch (exception) {
      throw new AnalysisException.con3(exception);
    }
    return scanner.result;
  }
  /**
   * <b>Note:</b> This method must only be invoked while we are synchronized on {@link #cacheLock}.
   * @param source the source that has been added
   */
  void sourceAvailable(Source source) {
    SourceInfo existingInfo = _sourceMap[source];
    if (existingInfo == null) {
      createSourceInfo(source);
    }
  }
  /**
   * <b>Note:</b> This method must only be invoked while we are synchronized on {@link #cacheLock}.
   * @param source the source that has been changed
   */
  void sourceChanged(Source source) {
    SourceInfo sourceInfo = _sourceMap[source];
    if (sourceInfo is HtmlUnitInfo) {
      HtmlUnitInfo htmlUnitInfo = sourceInfo as HtmlUnitInfo;
      htmlUnitInfo.invalidateLineInfo();
      htmlUnitInfo.invalidateParsedUnit();
      htmlUnitInfo.invalidateResolvedUnit();
    } else if (sourceInfo is CompilationUnitInfo) {
      CompilationUnitInfo compilationUnitInfo = sourceInfo as CompilationUnitInfo;
      for (Source librarySource in compilationUnitInfo.librarySources) {
        LibraryInfo libraryInfo = getLibraryInfo(librarySource);
        if (libraryInfo != null) {
          libraryInfo.invalidateElement();
          libraryInfo.invalidatePublicNamespace();
          libraryInfo.invalidateLaunchable();
          libraryInfo.invalidateClientServer();
        }
      }
      _sourceMap[source] = DartInfo.instance;
    }
  }
  /**
   * <b>Note:</b> This method must only be invoked while we are synchronized on {@link #cacheLock}.
   * @param source the source that has been deleted
   */
  void sourceRemoved(Source source) {
    CompilationUnitInfo compilationUnitInfo = getCompilationUnitInfo(source);
    if (compilationUnitInfo != null) {
      for (Source librarySource in compilationUnitInfo.librarySources) {
        LibraryInfo libraryInfo = getLibraryInfo(librarySource);
        if (libraryInfo != null) {
          libraryInfo.invalidateElement();
          libraryInfo.invalidatePublicNamespace();
          libraryInfo.invalidateLaunchable();
          libraryInfo.invalidateClientServer();
        }
      }
    }
    _sourceMap.remove(source);
  }
}
/**
 * Instances of the class {@code ScanResult} represent the results of scanning a source.
 */
class AnalysisContextImpl_ScanResult {
  /**
   * The first token in the token stream.
   */
  Token _token;
  /**
   * The line start information that was produced.
   */
  List<int> _lineStarts;
  /**
   * Initialize a newly created result object to be empty.
   */
  AnalysisContextImpl_ScanResult() : super() {
  }
}
class SimpleXmlVisitor_3 extends SimpleXmlVisitor<Object> {
  Source htmlSource;
  List<Source> libraries;
  SimpleXmlVisitor_3(this.htmlSource, this.libraries) : super();
  Object visitXmlTagNode(XmlTagNode node) {
    if (javaStringEqualsIgnoreCase(node.tag.lexeme, AnalysisContextImpl._TAG_SCRIPT)) {
      for (XmlAttributeNode attribute in node.attributes) {
        if (javaStringEqualsIgnoreCase(attribute.name.lexeme, AnalysisContextImpl._ATTRIBUTE_SRC)) {
          Source librarySource = htmlSource.resolve(attribute.value.lexeme);
          if (librarySource.exists()) {
            libraries.add(librarySource);
          }
        }
      }
    }
    return null;
  }
}
class Source_ContentReceiver_4 implements Source_ContentReceiver {
  Source source;
  AnalysisErrorListener errorListener;
  AnalysisContextImpl_ScanResult result;
  Source_ContentReceiver_4(this.source, this.errorListener, this.result);
  accept(CharBuffer contents) {
    CharBufferScanner scanner = new CharBufferScanner(source, contents, errorListener);
    result._token = scanner.tokenize();
    result._lineStarts = scanner.lineStarts;
  }
  void accept2(String contents) {
    StringScanner scanner = new StringScanner(source, contents, errorListener);
    result._token = scanner.tokenize();
    result._lineStarts = scanner.lineStarts;
  }
}
/**
 * The enumeration {@code CacheState} defines the possible states of cached data.
 */
class CacheState {
  /**
   * A state representing the fact that the data was up-to-date but flushed from the cache in order
   * to control memory usage.
   */
  static final CacheState FLUSHED = new CacheState('FLUSHED', 0);
  /**
   * A state representing the fact that the data was removed from the cache because it was invalid
   * and needs to be recomputed.
   */
  static final CacheState INVALID = new CacheState('INVALID', 1);
  /**
   * A state representing the fact that the data is in the cache and valid.
   */
  static final CacheState VALID = new CacheState('VALID', 2);
  static final List<CacheState> values = [FLUSHED, INVALID, VALID];
  final String __name;
  final int __ordinal;
  int get ordinal => __ordinal;
  CacheState(this.__name, this.__ordinal) {
  }
  String toString() => __name;
}
/**
 * Instances of the class {@code ChangeNoticeImpl} represent a change to the analysis results
 * associated with a given source.
 * @coverage dart.engine
 */
class ChangeNoticeImpl implements ChangeNotice {
  /**
   * The source for which the result is being reported.
   */
  Source _source;
  /**
   * The fully resolved AST that changed as a result of the analysis, or {@code null} if the AST was
   * not changed.
   */
  CompilationUnit _compilationUnit;
  /**
   * The errors that changed as a result of the analysis, or {@code null} if errors were not
   * changed.
   */
  List<AnalysisError> _errors;
  /**
   * The line information associated with the source, or {@code null} if errors were not changed.
   */
  LineInfo _lineInfo;
  /**
   * An empty array of change notices.
   */
  static List<ChangeNoticeImpl> EMPTY_ARRAY = new List<ChangeNoticeImpl>(0);
  /**
   * Initialize a newly created notice associated with the given source.
   * @param source the source for which the change is being reported
   */
  ChangeNoticeImpl(Source source) {
    this._source = source;
  }
  /**
   * Return the fully resolved AST that changed as a result of the analysis, or {@code null} if the
   * AST was not changed.
   * @return the fully resolved AST that changed as a result of the analysis
   */
  CompilationUnit get compilationUnit => _compilationUnit;
  /**
   * Return the errors that changed as a result of the analysis, or {@code null} if errors were not
   * changed.
   * @return the errors that changed as a result of the analysis
   */
  List<AnalysisError> get errors => _errors;
  /**
   * Return the line information associated with the source, or {@code null} if errors were not
   * changed.
   * @return the line information associated with the source
   */
  LineInfo get lineInfo => _lineInfo;
  /**
   * Return the source for which the result is being reported.
   * @return the source for which the result is being reported
   */
  Source get source => _source;
  /**
   * Set the fully resolved AST that changed as a result of the analysis to the given AST.
   * @param compilationUnit the fully resolved AST that changed as a result of the analysis
   */
  void set compilationUnit(CompilationUnit compilationUnit9) {
    this._compilationUnit = compilationUnit9;
  }
  /**
   * Set the errors that changed as a result of the analysis to the given errors and set the line
   * information to the given line information.
   * @param errors the errors that changed as a result of the analysis
   * @param lineInfo the line information associated with the source
   */
  void setErrors(List<AnalysisError> errors2, LineInfo lineInfo3) {
    this._errors = errors2;
    this._lineInfo = lineInfo3;
  }
}
/**
 * Instances of the class {@code CompilationUnitInfo} maintain the information cached by an analysis
 * context about an individual compilation unit.
 * @coverage dart.engine
 */
class CompilationUnitInfo extends SourceInfo {
  /**
   * The state of the cached parsed compilation unit.
   */
  CacheState _parsedUnitState = CacheState.INVALID;
  /**
   * The parsed compilation unit, or {@code null} if the parsed compilation unit is not currently
   * cached.
   */
  CompilationUnit _parsedUnit;
  /**
   * The state of the cached resolved compilation unit.
   */
  CacheState _resolvedUnitState = CacheState.INVALID;
  /**
   * The resolved compilation unit, or {@code null} if the resolved compilation unit is not
   * currently cached.
   */
  CompilationUnit _resolvedUnit;
  /**
   * The state of the cached parse errors.
   */
  CacheState _parseErrorsState = CacheState.INVALID;
  /**
   * The errors produced while scanning and parsing the compilation unit, or {@code null} if the
   * errors are not currently cached.
   */
  List<AnalysisError> _parseErrors;
  /**
   * The state of the cached resolution errors.
   */
  CacheState _resolutionErrorsState = CacheState.INVALID;
  /**
   * The errors produced while resolving the compilation unit, or {@code null} if the errors are not
   * currently cached.
   */
  List<AnalysisError> _resolutionErrors;
  /**
   * The sources for the defining compilation units of the libraries containing the source, or{@code null} if the libraries containing the source are not yet known.
   */
  List<Source> _librarySources = null;
  /**
   * Initialize a newly created information holder to be empty.
   */
  CompilationUnitInfo() : super() {
  }
  /**
   * Add the given source to the list of sources for the defining compilation units for the
   * libraries containing this source.
   * @param source the source to be added to the list
   */
  void addLibrarySource(Source source) {
    if (_librarySources == null) {
      _librarySources = new List<Source>();
    }
    _librarySources.add(source);
  }
  /**
   * Remove the parsed compilation unit from the cache.
   */
  void clearParsedUnit() {
    _parsedUnit = null;
  }
  /**
   * Remove the parse errors from the cache.
   */
  void clearParseErrors() {
    _parseErrors = null;
  }
  /**
   * Remove the resolution errors from the cache.
   */
  void clearResolutionErrors() {
    _resolutionErrors = null;
  }
  /**
   * Remove the resolved compilation unit from the cache.
   */
  void clearResolvedUnit() {
    _resolvedUnit = null;
  }
  CompilationUnitInfo copy() {
    CompilationUnitInfo copy = new CompilationUnitInfo();
    copy.copyFrom(this);
    return copy;
  }
  /**
   * Return all of the errors associated with the compilation unit.
   * @return all of the errors associated with the compilation unit
   */
  List<AnalysisError> get allErrors {
    if (_parseErrors == null) {
      if (_resolutionErrors == null) {
        return null;
      }
      return _resolutionErrors;
    } else if (_resolutionErrors == null) {
      return _parseErrors;
    }
    int parseCount = _parseErrors.length;
    int resolutionCount = _resolutionErrors.length;
    List<AnalysisError> errors = new List<AnalysisError>(parseCount + resolutionCount);
    JavaSystem.arraycopy(_parseErrors, 0, errors, 0, parseCount);
    JavaSystem.arraycopy(_resolutionErrors, 0, errors, parseCount, resolutionCount);
    return errors;
  }
  SourceKind get kind => SourceKind.PART;
  /**
   * Return the sources for the defining compilation units for the libraries containing this source.
   * @return the sources for the defining compilation units for the libraries containing this source
   */
  List<Source> get librarySources {
    if (_librarySources == null) {
      return Source.EMPTY_ARRAY;
    }
    return new List.from(_librarySources);
  }
  /**
   * Return the parsed compilation unit, or {@code null} if the parsed compilation unit is not
   * currently cached.
   * @return the parsed compilation unit
   */
  CompilationUnit get parsedCompilationUnit => _parsedUnit;
  /**
   * Return the errors produced while scanning and parsing the compilation unit, or {@code null} if
   * the errors are not currently cached.
   * @return the errors produced while scanning and parsing the compilation unit
   */
  List<AnalysisError> get parseErrors => _parseErrors;
  /**
   * Return the errors produced while resolving the compilation unit, or {@code null} if the errors
   * are not currently cached.
   * @return the errors produced while resolving the compilation unit
   */
  List<AnalysisError> get resolutionErrors => _resolutionErrors;
  /**
   * Return the resolved compilation unit, or {@code null} if the resolved compilation unit is not
   * currently cached.
   * @return the resolved compilation unit
   */
  CompilationUnit get resolvedCompilationUnit => _resolvedUnit;
  /**
   * Return {@code true} if the parsed compilation unit needs to be recomputed.
   * @return {@code true} if the parsed compilation unit needs to be recomputed
   */
  bool hasInvalidParsedUnit() => identical(_parsedUnitState, CacheState.INVALID);
  /**
   * Return {@code true} if the parse errors needs to be recomputed.
   * @return {@code true} if the parse errors needs to be recomputed
   */
  bool hasInvalidParseErrors() => identical(_parseErrorsState, CacheState.INVALID);
  /**
   * Return {@code true} if the resolution errors needs to be recomputed.
   * @return {@code true} if the resolution errors needs to be recomputed
   */
  bool hasInvalidResolutionErrors() => identical(_resolutionErrorsState, CacheState.INVALID);
  /**
   * Return {@code true} if the resolved compilation unit needs to be recomputed.
   * @return {@code true} if the resolved compilation unit needs to be recomputed
   */
  bool hasInvalidResolvedUnit() => identical(_resolvedUnitState, CacheState.INVALID);
  /**
   * Mark the parsed compilation unit as needing to be recomputed.
   */
  void invalidateParsedUnit() {
    _parsedUnitState = CacheState.INVALID;
    _parsedUnit = null;
  }
  /**
   * Mark the parse errors as needing to be recomputed.
   */
  void invalidateParseErrors() {
    _parseErrorsState = CacheState.INVALID;
    _parseErrors = null;
  }
  /**
   * Mark the resolution errors as needing to be recomputed.
   */
  void invalidateResolutionErrors() {
    _resolutionErrorsState = CacheState.INVALID;
    _resolutionErrors = null;
  }
  /**
   * Mark the resolved compilation unit as needing to be recomputed.
   */
  void invalidateResolvedUnit() {
    _resolvedUnitState = CacheState.INVALID;
    _resolvedUnit = null;
  }
  /**
   * Remove the given source from the list of sources for the defining compilation units for the
   * libraries containing this source.
   * @param source the source to be removed to the list
   */
  void removeLibrarySource(Source source) {
    if (_librarySources != null) {
      _librarySources.remove(source);
      if (_librarySources.isEmpty) {
        _librarySources = null;
      }
    }
  }
  /**
   * Set the parsed compilation unit to the given compilation unit.
   * <p>
   * <b>Note:</b> Do not use this method to clear or invalidate the parsed compilation unit. Use
   * either {@link #clear} or {@link #invalidate}.
   * @param unit the parsed compilation unit
   */
  void set parsedCompilationUnit(CompilationUnit unit) {
    _parsedUnit = unit;
    _parsedUnitState = CacheState.VALID;
  }
  /**
   * Set the errors produced while scanning and parsing the compilation unit to the given errors.
   * <p>
   * <b>Note:</b> Do not use this method to clear or invalidate the parse errors. Use either{@link #clear} or {@link #invalidate}.
   * @param errors the errors produced while scanning and parsing the compilation unit
   */
  void set parseErrors(List<AnalysisError> errors) {
    _parseErrors = errors;
    _parseErrorsState = CacheState.VALID;
  }
  /**
   * Set the errors produced while resolving the compilation unit to the given errors.
   * <p>
   * <b>Note:</b> Do not use this method to clear or invalidate the resolution errors. Use either{@link #clear} or {@link #invalidate}.
   * @param errors the errors produced while resolving the compilation unit
   */
  void set resolutionErrors(List<AnalysisError> errors) {
    _resolutionErrors = errors;
    _resolutionErrorsState = CacheState.VALID;
  }
  /**
   * Set the resolved compilation unit to the given compilation unit.
   * <p>
   * <b>Note:</b> Do not use this method to clear or invalidate the resolved compilation unit. Use
   * either {@link #clear} or {@link #invalidate}.
   * @param unit the resolved compilation unit
   */
  void set resolvedCompilationUnit(CompilationUnit unit) {
    _resolvedUnit = unit;
    _resolvedUnitState = CacheState.VALID;
  }
  void copyFrom(SourceInfo info) {
    super.copyFrom(info);
  }
}
/**
 * The unique instance of the class {@code DartInfo} acts as a placeholder for Dart compilation
 * units that have not yet had their kind computed.
 * @coverage dart.engine
 */
class DartInfo extends SourceInfo {
  /**
   * The unique instance of this class.
   */
  static DartInfo _UniqueInstance = new DartInfo();
  /**
   * Return the unique instance of this class.
   * @return the unique instance of this class
   */
  static DartInfo get instance => _UniqueInstance;
  /**
   * Prevent the creation of instances of this class.
   */
  DartInfo() : super() {
  }
  DartInfo copy() => this;
  SourceKind get kind => SourceKind.UNKNOWN;
}
/**
 * Instances of the class {@code HtmlUnitInfo} maintain the information cached by an analysis
 * context about an individual HTML file.
 * @coverage dart.engine
 */
class HtmlUnitInfo extends SourceInfo {
  /**
   * The state of the cached parsed (but not resolved) HTML unit.
   */
  CacheState _parsedUnitState = CacheState.INVALID;
  /**
   * The parsed HTML unit, or {@code null} if the parsed HTML unit is not currently cached.
   */
  HtmlUnit _parsedUnit;
  /**
   * The state of the cached parsed and resolved HTML unit.
   */
  CacheState _resolvedUnitState = CacheState.INVALID;
  /**
   * The resolved HTML unit, or {@code null} if the resolved HTML unit is not currently cached.
   */
  HtmlUnit _resolvedUnit;
  /**
   * The state of the cached HTML element.
   */
  CacheState _elementState = CacheState.INVALID;
  /**
   * The element representing the HTML file, or {@code null} if the element is not currently cached.
   */
  HtmlElement _element;
  /**
   * Initialize a newly created information holder to be empty.
   */
  HtmlUnitInfo() : super() {
  }
  /**
   * Remove the parsed HTML unit from the cache.
   */
  void clearParsedUnit() {
    _parsedUnit = null;
  }
  /**
   * Remove the resolved HTML unit from the cache.
   */
  void clearResolvedUnit() {
    _resolvedUnit = null;
  }
  HtmlUnitInfo copy() {
    HtmlUnitInfo copy = new HtmlUnitInfo();
    copy.copyFrom(this);
    return copy;
  }
  /**
   * Return the element representing the HTML file, or {@code null} if the element is not currently
   * cached.
   * @return the element representing the HTML file
   */
  HtmlElement get element => _element;
  SourceKind get kind => SourceKind.HTML;
  /**
   * Return the parsed HTML unit, or {@code null} if the parsed HTML unit is not currently cached.
   * @return the parsed HTML unit
   */
  HtmlUnit get parsedUnit => _parsedUnit;
  /**
   * Return the resolved HTML unit, or {@code null} if the resolved HTML unit is not currently
   * cached.
   * @return the resolved HTML unit
   */
  HtmlUnit get resolvedUnit => _resolvedUnit;
  /**
   * Return {@code true} if the HTML element needs to be recomputed.
   * @return {@code true} if the HTML element needs to be recomputed
   */
  bool hasInvalidElement() => identical(_elementState, CacheState.INVALID);
  /**
   * Return {@code true} if the parsed HTML unit needs to be recomputed.
   * @return {@code true} if the parsed HTML unit needs to be recomputed
   */
  bool hasInvalidParsedUnit() => identical(_parsedUnitState, CacheState.INVALID);
  /**
   * Return {@code true} if the resolved HTML unit needs to be recomputed.
   * @return {@code true} if the resolved HTML unit needs to be recomputed
   */
  bool hasInvalidResolvedUnit() => identical(_resolvedUnitState, CacheState.INVALID);
  /**
   * Mark the HTML element as needing to be recomputed.
   */
  void invalidateElement() {
    _elementState = CacheState.INVALID;
    _element = null;
  }
  /**
   * Mark the parsed HTML unit as needing to be recomputed.
   */
  void invalidateParsedUnit() {
    _parsedUnitState = CacheState.INVALID;
    _parsedUnit = null;
  }
  /**
   * Mark the resolved HTML unit as needing to be recomputed.
   */
  void invalidateResolvedUnit() {
    _resolvedUnitState = CacheState.INVALID;
    _resolvedUnit = null;
  }
  /**
   * Set the element representing the HTML file to the given element.
   * <p>
   * <b>Note:</b> Do not use this method to clear or invalidate the element. Use either{@link #clearElement()} or {@link #invalidateElement()}.
   * @param element the element representing the HTML file
   */
  void set element(HtmlElement element19) {
    this._element = element19;
    _elementState = CacheState.VALID;
  }
  /**
   * Set the parsed HTML unit to the given HTML unit.
   * <p>
   * <b>Note:</b> Do not use this method to clear or invalidate the HTML unit. Use either{@link #clearParsedUnit()} or {@link #invalidateParsedUnit()}.
   * @param unit the result of parsing the source as an HTML unit
   */
  void set parsedUnit(HtmlUnit unit) {
    _parsedUnit = unit;
    _parsedUnitState = CacheState.VALID;
  }
  /**
   * Set the resolved HTML unit to the given HTML unit.
   * <p>
   * <b>Note:</b> Do not use this method to clear or invalidate the HTML unit. Use either{@link #clearResolvedUnit()} or {@link #invalidateResolvedUnit()}.
   * @param unit the result of resolving the source as an HTML unit
   */
  void set resolvedUnit(HtmlUnit unit) {
    _resolvedUnit = unit;
    _resolvedUnitState = CacheState.VALID;
  }
  void copyFrom(SourceInfo info) {
    super.copyFrom(info);
  }
}
/**
 * Instances of the class {@code LibraryInfo} maintain the information cached by an analysis context
 * about an individual library.
 * @coverage dart.engine
 */
class LibraryInfo extends CompilationUnitInfo {
  /**
   * Mask indicating that this library is launchable: that the file has a main method.
   */
  static int _LAUNCHABLE = 1 << 1;
  /**
   * Mask indicating that the library is client code: that the library depends on the html library.
   * If the library is not "client code", then it is referenced as "server code".
   */
  static int _CLIENT_CODE = 1 << 2;
  /**
   * The state of the cached library element.
   */
  CacheState _elementState = CacheState.INVALID;
  /**
   * The element representing the library, or {@code null} if the element is not currently cached.
   */
  LibraryElement _element;
  /**
   * The state of the cached public namespace.
   */
  CacheState _publicNamespaceState = CacheState.INVALID;
  /**
   * The public namespace of the library, or {@code null} if the namespace is not currently cached.
   */
  Namespace _publicNamespace;
  /**
   * The state of the cached client/ server flag.
   */
  CacheState _clientServerState = CacheState.INVALID;
  /**
   * The state of the cached launchable flag.
   */
  CacheState _launchableState = CacheState.INVALID;
  /**
   * An integer holding bit masks such as {@link #LAUNCHABLE} and {@link #CLIENT_CODE}.
   */
  int _bitmask = 0;
  /**
   * The sources for the HTML files that reference this library (via a script tag), or {@code null}if there are no HTML files that reference the library or if the HTML files are not yet known.
   */
  List<Source> _htmlSources = null;
  /**
   * Initialize a newly created information holder to be empty.
   */
  LibraryInfo() : super() {
  }
  /**
   * Add the given source to the list of sources for the HTML files that reference this library.
   * @param source the source to be added to the list
   */
  void addHtmlSource(Source source) {
    if (_htmlSources == null) {
      _htmlSources = new List<Source>();
    }
    _htmlSources.add(source);
  }
  /**
   * Remove the library element from the cache.
   */
  void clearElement() {
    _element = null;
  }
  /**
   * Remove the public namespace from the cache.
   */
  void clearPublicNamespace() {
    _publicNamespace = null;
  }
  LibraryInfo copy() {
    LibraryInfo copy = new LibraryInfo();
    copy.copyFrom(this);
    return copy;
  }
  /**
   * Return the element representing the library, or {@code null} if the element is not currently
   * cached.
   * @return the element representing the library
   */
  LibraryElement get element => _element;
  /**
   * Return the sources for the HTML files that reference this library.
   * @return the sources for the HTML files that reference this library
   */
  List<Source> get htmlSources {
    if (_htmlSources == null) {
      return Source.EMPTY_ARRAY;
    }
    return new List.from(_htmlSources);
  }
  SourceKind get kind => SourceKind.LIBRARY;
  /**
   * Return the public namespace of the library, or {@code null} if the namespace is not currently
   * cached.
   * @return the public namespace of the library
   */
  Namespace get publicNamespace => _publicNamespace;
  /**
   * Return {@code true} if the client/ server flag needs to be recomputed.
   * @return {@code true} if the client/ server flag needs to be recomputed
   */
  bool hasInvalidClientServer() => identical(_clientServerState, CacheState.INVALID);
  /**
   * Return {@code true} if the library element needs to be recomputed.
   * @return {@code true} if the library element needs to be recomputed
   */
  bool hasInvalidElement() => identical(_elementState, CacheState.INVALID);
  /**
   * Return {@code true} if the launchable flag needs to be recomputed.
   * @return {@code true} if the launchable flag needs to be recomputed
   */
  bool hasInvalidLaunchable() => identical(_launchableState, CacheState.INVALID);
  /**
   * Return {@code true} if the public namespace needs to be recomputed.
   * @return {@code true} if the public namespace needs to be recomputed
   */
  bool hasInvalidPublicNamespace() => identical(_publicNamespaceState, CacheState.INVALID);
  /**
   * Mark the client/ server flag as needing to be recomputed.
   */
  void invalidateClientServer() {
    _clientServerState = CacheState.INVALID;
    _bitmask &= ~_CLIENT_CODE;
  }
  /**
   * Mark the library element as needing to be recomputed.
   */
  void invalidateElement() {
    _elementState = CacheState.INVALID;
    _element = null;
  }
  /**
   * Mark the launchable flag as needing to be recomputed.
   */
  void invalidateLaunchable() {
    _launchableState = CacheState.INVALID;
    _bitmask &= ~_LAUNCHABLE;
  }
  /**
   * Mark the public namespace as needing to be recomputed.
   */
  void invalidatePublicNamespace() {
    _publicNamespaceState = CacheState.INVALID;
    _publicNamespace = null;
  }
  /**
   * Return <code>true</code> if this library is client based code: the library depends on the html
   * library.
   * @return <code>true</code> if this library is client based code: the library depends on the html
   * library
   */
  bool isClient() => (_bitmask & _CLIENT_CODE) != 0;
  /**
   * Return <code>true</code> if this library is launchable: the file includes a main method.
   * @return <code>true</code> if this library is launchable: the file includes a main method
   */
  bool isLaunchable() => (_bitmask & _LAUNCHABLE) != 0;
  /**
   * Return <code>true</code> if this library is server based code: the library does not depends on
   * the html library.
   * @return <code>true</code> if this library is server based code: the library does not depends on
   * the html library
   */
  bool isServer() => (_bitmask & _CLIENT_CODE) == 0;
  /**
   * Remove the given source from the list of sources for the HTML files that reference this
   * library.
   * @param source the source to be removed to the list
   */
  void removeHtmlSource(Source source) {
    if (_htmlSources != null) {
      _htmlSources.remove(source);
      if (_htmlSources.isEmpty) {
        _htmlSources = null;
      }
    }
  }
  /**
   * Sets the value of the client/ server flag.
   * <p>
   * <b>Note:</b> Do not use this method to invalidate the flag, use{@link #invalidateClientServer()}.
   * @param isClient the new value of the client flag
   */
  void set client(bool isClient) {
    if (isClient) {
      _bitmask |= _CLIENT_CODE;
    } else {
      _bitmask &= ~_CLIENT_CODE;
    }
    _clientServerState = CacheState.VALID;
  }
  /**
   * Set the element representing the library to the given element.
   * <p>
   * <b>Note:</b> Do not use this method to clear or invalidate the element. Use either{@link #clearElement()} or {@link #invalidateElement()}.
   * @param element the element representing the library
   */
  void set element(LibraryElement element20) {
    this._element = element20;
    _elementState = CacheState.VALID;
  }
  /**
   * Sets the value of the launchable flag.
   * <p>
   * <b>Note:</b> Do not use this method to invalidate the flag, use {@link #invalidateLaunchable()}.
   * @param isClient the new value of the client flag
   */
  void set launchable(bool launchable2) {
    if (launchable2) {
      _bitmask |= _LAUNCHABLE;
    } else {
      _bitmask &= ~_LAUNCHABLE;
    }
    _launchableState = CacheState.VALID;
  }
  /**
   * Set the public namespace of the library to the given namespace.
   * <p>
   * <b>Note:</b> Do not use this method to clear or invalidate the element. Use either{@link #clearPublicNamespace()} or {@link #invalidatePublicNamespace()}.
   * @param namespace the public namespace of the library
   */
  void set publicNamespace(Namespace namespace) {
    _publicNamespace = namespace;
    _publicNamespaceState = CacheState.VALID;
  }
  void copyFrom(SourceInfo info) {
    super.copyFrom(info);
  }
}
/**
 * Instances of the class {@code RecordingErrorListener} implement an error listener that will
 * record the errors that are reported to it in a way that is appropriate for caching those errors
 * within an analysis context.
 * @coverage dart.engine
 */
class RecordingErrorListener implements AnalysisErrorListener {
  /**
   * A HashMap of lists containing the errors that were collected, keyed by each {@link Source}.
   */
  Map<Source, List<AnalysisError>> _errors = new Map<Source, List<AnalysisError>>();
  /**
   * Answer the errors collected by the listener.
   * @return an array of errors (not {@code null}, contains no {@code null}s)
   */
  List<AnalysisError> get errors {
    Set<MapEntry<Source, List<AnalysisError>>> entrySet2 = getMapEntrySet(_errors);
    if (entrySet2.length == 0) {
      return AnalysisError.NO_ERRORS;
    }
    List<AnalysisError> resultList = new List<AnalysisError>();
    for (MapEntry<Source, List<AnalysisError>> entry in entrySet2) {
      resultList.addAll(entry.getValue());
    }
    return new List.from(resultList);
  }
  /**
   * Answer the errors collected by the listener for some passed {@link Source}.
   * @param source some {@link Source} for which the caller wants the set of {@link AnalysisError}s
   * collected by this listener
   * @return the errors collected by the listener for the passed {@link Source}
   */
  List<AnalysisError> getErrors2(Source source) {
    List<AnalysisError> errorsForSource = _errors[source];
    if (errorsForSource == null) {
      return AnalysisError.NO_ERRORS;
    } else {
      return new List.from(errorsForSource);
    }
  }
  void onError(AnalysisError event) {
    Source source9 = event.source;
    List<AnalysisError> errorsForSource = _errors[source9];
    if (_errors[source9] == null) {
      errorsForSource = new List<AnalysisError>();
      _errors[source9] = errorsForSource;
    }
    errorsForSource.add(event);
  }
}
/**
 * Instances of the class {@code SourceInfo} maintain the information cached by an analysis context
 * about an individual source.
 * @coverage dart.engine
 */
abstract class SourceInfo {
  /**
   * The state of the cached line information.
   */
  CacheState _lineInfoState = CacheState.INVALID;
  /**
   * The line information computed for the source, or {@code null} if the line information is not
   * currently cached.
   */
  LineInfo _lineInfo;
  /**
   * Initialize a newly created information holder to be empty.
   */
  SourceInfo() : super() {
  }
  /**
   * Remove the line information from the cache.
   */
  void clearLineInfo() {
    _lineInfo = null;
  }
  /**
   * Return a copy of this information holder.
   * @return a copy of this information holder
   */
  SourceInfo copy();
  /**
   * Return the kind of the source, or {@code null} if the kind is not currently cached.
   * @return the kind of the source
   */
  SourceKind get kind;
  /**
   * Return the line information computed for the source, or {@code null} if the line information is
   * not currently cached.
   * @return the line information computed for the source
   */
  LineInfo get lineInfo => _lineInfo;
  /**
   * Return {@code true} if the line information needs to be recomputed.
   * @return {@code true} if the line information needs to be recomputed
   */
  bool hasInvalidLineInfo() => identical(_lineInfoState, CacheState.INVALID);
  /**
   * Mark the line information as needing to be recomputed.
   */
  void invalidateLineInfo() {
    _lineInfoState = CacheState.INVALID;
    _lineInfo = null;
  }
  /**
   * Set the line information for the source to the given line information.
   * <p>
   * <b>Note:</b> Do not use this method to clear or invalidate the element. Use either{@link #clearLineInfo()} or {@link #invalidateLineInfo()}.
   * @param info the line information for the source
   */
  void set lineInfo(LineInfo info) {
    _lineInfo = info;
    _lineInfoState = CacheState.VALID;
  }
  /**
   * Copy the information from the given information holder.
   * @param info the information holder from which information will be copied
   */
  void copyFrom(SourceInfo info) {
    _lineInfoState = info._lineInfoState;
    _lineInfo = info._lineInfo;
  }
}
/**
 * The interface {@code Logger} defines the behavior of objects that can be used to receive
 * information about errors within the analysis engine. Implementations usually write this
 * information to a file, but can also record the information for later use (such as during testing)
 * or even ignore the information.
 * @coverage dart.engine.utilities
 */
abstract class Logger {
  static Logger NULL = new Logger_NullLogger();
  /**
   * Log the given message as an error.
   * @param message an explanation of why the error occurred or what it means
   */
  void logError(String message);
  /**
   * Log the given exception as one representing an error.
   * @param message an explanation of why the error occurred or what it means
   * @param exception the exception being logged
   */
  void logError2(String message, Exception exception);
  /**
   * Log the given exception as one representing an error.
   * @param exception the exception being logged
   */
  void logError3(Exception exception);
  /**
   * Log the given informational message.
   * @param message an explanation of why the error occurred or what it means
   * @param exception the exception being logged
   */
  void logInformation(String message);
  /**
   * Log the given exception as one representing an informational message.
   * @param message an explanation of why the error occurred or what it means
   * @param exception the exception being logged
   */
  void logInformation2(String message, Exception exception);
}
/**
 * Implementation of {@link Logger} that does nothing.
 */
class Logger_NullLogger implements Logger {
  void logError(String message) {
  }
  void logError2(String message, Exception exception) {
  }
  void logError3(Exception exception) {
  }
  void logInformation(String message) {
  }
  void logInformation2(String message, Exception exception) {
  }
}