import 'package:analyzer/dart/element/element.dart';
import 'package:dartagram/src/constants.dart';
import 'package:dartagram/src/visitor.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group('PlantUmlVisitor', () {
    PlantUmlVisitor visitor;

    setUp(() {
      visitor = new PlantUmlVisitor();
    });

    group('getFullTypeName', () {
      Element element;
      LibraryElement library;

      setUp(() {
        element = new MockElement();
        library = new MockLibraryElement();

        when(element.name).thenReturn('class');
        when(element.library).thenReturn(library);
      });

      test('should concatenate package and class name', () {
        when(library.identifier).thenReturn('package:pkg/entry.dart');
        final fullName = visitor.getFullTypeName(element);
        expect(
          fullName,
          [
            'pkg',
            'entry.dart',
            'class',
          ].join(namespaceSeparator),
        );
      });

      test('should convert a dart:core prefix to dart::core', () {
        when(library.identifier).thenReturn('dart:core/entry.dart');
        final fullName = visitor.getFullTypeName(element);
        expect(
          fullName,
          [
            'dart',
            'core',
            'entry.dart',
            'class',
          ].join(namespaceSeparator),
        );
      });
    });
  });
}

class MockElement extends Mock implements Element {}

class MockLibraryElement extends Mock implements LibraryElement {}
