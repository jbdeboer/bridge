import 'package:unittest/unittest.dart';

import '../lib/src/analyzer_experimental/element.dart' as element;
import '../lib/src/identifier_translations.dart';
import '../lib/src/lexical_scope.dart';
import '../lib/src/type_factory.dart';

final element.Type2 FOO_TYPE = typeFactory('Foo', null);
final element.Type2 ARRAY_TYPE = typeFactory('List', []);

main() {
  NameTranslator translator;
  TranslationContext context;
  group('ArrayTranslator', () {
    setUp(() { translator = new ArrayTranslator(); });

    test('should not translate global methods', () {
      context = new TranslationContext(
          isPrefixed: false, currentScope: LexicalScope.UNQUALIFIED, currentType: null);
      expect(translator.translateName("sqrt", context), isNull);
    });

    test('should not translate non-array methods', () {
      TranslationContext context;
      context = new TranslationContext(
          isPrefixed: true, currentScope: LexicalScope.UNQUALIFIED, currentType: null);
      expect(translator.translateName("sqrt", context), isNull);

      context = new TranslationContext(
          isPrefixed: true, currentScope: LexicalScope.UNQUALIFIED, currentType: FOO_TYPE);
      expect(translator.translateName("sqrt", context), isNull);

      context = new TranslationContext(
          isPrefixed: false, currentScope: LexicalScope.METHOD, currentType: null);
      expect(translator.translateName("sqrt", context), isNull);

      context = new TranslationContext(
          isPrefixed: true, currentScope: LexicalScope.METHOD, currentType: null);
      expect(translator.translateName("sqrt", context), isNull);

      context = new TranslationContext(
          isPrefixed: true, currentScope: LexicalScope.METHOD, currentType: FOO_TYPE);
      expect(translator.translateName("sqrt", context), isNull);
    });

    group('ArrayTranslator in array method context', () {
      setUp(() {
        context = new TranslationContext(
            isPrefixed: true, currentScope: LexicalScope.METHOD, currentType: ARRAY_TYPE);
      });

      test('should translate add to push', () {
        expect(translator.translateName("add", context), equals("push"));
      });

      test('should translate removeRange to splice', () {
        expect(translator.translateName("removeRange", context), equals("splice"));
      });

      test('should translate where to filter', () {
        expect(translator.translateName("where", context), equals("filter"));
      });

      test('should pass through forEach', () {
        expect(translator.translateName("forEach", context), equals("forEach"));
      });

      test('should pass through indexOf', () {
        expect(translator.translateName("indexOf", context), equals("indexOf"));
      });

      test('should pass through every', () {
        expect(translator.translateName("every", context), equals("every"));
      });

      test('should not translate unknown method FOO', () {
        expect(translator.translateName("FOO", context), isNull);
      });

    }); // end group(''ArrayTranslator in array method context')

  }); // end group('ArrayTranslator')

  group('GlobalNameTranslator', () {
    setUp(() {
      translator = new GlobalNameTranslator();
      context = new TranslationContext(
          isPrefixed: false, currentScope: LexicalScope.UNQUALIFIED, currentType: null);
    });

    test('should translate sqrt', () {
      expect(translator.translateName("sqrt", context), equals("Math.sqrt"));
    });

    test('should translate PI', () {
      expect(translator.translateName("PI", context), equals("Math.PI"));
    });

    test('should translate min', () {
      expect(translator.translateName("min", context), equals("Math.min"));
    });

    test('should translate max', () {
      expect(translator.translateName("max", context), equals("Math.max"));
    });

    test('should NOT translate FOO', () {
      expect(translator.translateName("FOO", context), isNull);
    });

  }); // end group('GlobalNameTranslator')
}
