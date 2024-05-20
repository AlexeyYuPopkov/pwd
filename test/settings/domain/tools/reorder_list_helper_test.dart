import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/tools/list_helper.dart';

final class _ParamsIsEqual<T> {
  final List<T> src;
  final List<T> expected;

  _ParamsIsEqual({
    required this.src,
    required this.expected,
  });
}

final class _ParamsReorder<T> {
  final List<T> src;
  final List<T> expected;
  final int oldIndex;
  final int newIndex;

  _ParamsReorder({
    required this.src,
    required this.expected,
    required this.oldIndex,
    required this.newIndex,
  });
}

final class _Sut with ListHelper {
  const _Sut();
}

void main() {
  const sut = _Sut();

  group('ListHelper isEqual', () {
    test('isEqual - true', () {
      final a = ['a', 'b', 'c'];
      final identicalToA = a;

      for (final e in [
        _ParamsIsEqual(
          src: a,
          expected: identicalToA,
        ),
        _ParamsIsEqual(
          src: [],
          expected: [],
        ),
        _ParamsIsEqual(
          src: [0, 1, 2, 3, 4],
          expected: [0, 1, 2, 3, 4],
        ),
        _ParamsIsEqual(
          src: ['a', 'b', 'c', 'd', 'e'],
          expected: ['a', 'b', 'c', 'd', 'e'],
        ),
      ]) {
        final result = sut.isEqual(e.src, e.expected);

        expect(result, true);
      }
    });

    test('isEqual - false', () {
      for (final e in [
        _ParamsIsEqual(
          src: [],
          expected: [1],
        ),
        _ParamsIsEqual(
          src: [0, 1, 2],
          expected: ['a', 'b', 'c'],
        ),
        _ParamsIsEqual(
          src: ['a', 'b', 'c', 'd'],
          expected: ['a', 'b', 'c', 'd', 'e'],
        ),
        _ParamsIsEqual(
          src: ['a', 'b', 'c', 'd'],
          expected: ['A', 'b', 'c', 'd'],
        ),
      ]) {
        final result = sut.isEqual(e.src, e.expected);

        expect(result, false);
      }
    });
  });
  group('ListHelper reorder', () {
    test('isEqual - false', () {
      for (final e in [
        _ParamsIsEqual(
          src: [],
          expected: [1],
        ),
        _ParamsIsEqual(
          src: [0, 1, 2, 3],
          expected: [0, 1, 2, 3, 4],
        ),
        _ParamsIsEqual(
          src: [0, 1, 2, 3, 4],
          expected: [4, 3, 2, 1],
        ),
        _ParamsIsEqual(
          src: ['a', 'b', 'c', 'd', 'e'],
          expected: ['A', 'b', 'c', 'd', 'e'],
        ),
      ]) {
        final result = sut.isEqual(e.src, e.expected);

        expect(result, false);
      }
    });

    test('moveItem to right (down)', () {
      for (final e in [
        _ParamsReorder(
          src: [0, 1, 2, 3, 4],
          expected: [1, 2, 3, 4, 0],
          oldIndex: 0,
          newIndex: 4,
        ),
        _ParamsReorder(
          src: [0, 1, 2, 3, 4],
          expected: [1, 2, 3, 0, 4],
          oldIndex: 0,
          newIndex: 3,
        ),
        _ParamsReorder(
          src: [0, 1, 2, 3, 4],
          expected: [0, 2, 1, 3, 4],
          oldIndex: 1,
          newIndex: 2,
        ),
        _ParamsReorder(
          src: [0, 1, 2, 3, 4],
          expected: [0, 2, 3, 1, 4],
          oldIndex: 1,
          newIndex: 3,
        ),
        _ParamsReorder(
          src: [0, 1, 2, 3, 4],
          expected: [0, 1, 2, 3, 4],
          oldIndex: 3,
          newIndex: 3,
        ),
      ]) {
        final result = sut.moveItem(
          src: e.src,
          oldIndex: e.oldIndex,
          newIndex: e.newIndex,
        );
        expect(
          sut.isEqual(
            result,
            e.expected,
          ),
          true,
        );
      }
    });

    test('moveItem to left (up)', () {
      for (final e in [
        _ParamsReorder(
          src: [0, 1, 2, 3, 4],
          expected: [4, 0, 1, 2, 3],
          oldIndex: 4,
          newIndex: 0,
        ),
        _ParamsReorder(
          src: [0, 1, 2, 3, 4],
          expected: [3, 0, 1, 2, 4],
          oldIndex: 3,
          newIndex: 0,
        ),
        _ParamsReorder(
          src: [0, 1, 2, 3, 4],
          expected: [0, 2, 1, 3, 4],
          oldIndex: 2,
          newIndex: 1,
        ),
      ]) {
        final result = sut.moveItem(
          src: e.src,
          oldIndex: e.oldIndex,
          newIndex: e.newIndex,
        );
        expect(
          sut.isEqual(
            result,
            e.expected,
          ),
          true,
        );
      }
    });
  });
}
