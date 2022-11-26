library halo_dart;

import 'dart:async';
import "dart:math";

var kLoremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

extension HaloIterable<E> on Iterable<E> {
  List<E> get l => toList(growable: false);
}

extension HaloList<T> on List<T> {
  /// [dart growable performance](https://stackoverflow.com/questions/15943890/is-there-a-performance-benefit-in-using-fixed-length-lists-in-dart)
  List<R> indexMap<R>(
    R Function(int index, T value) convert, {
    bool growable = false,
  }) {
    final result = asMap()
        .map((index, value) {
          return MapEntry(
            index,
            convert(index, value),
          );
        })
        .values
        .toList(growable: growable);
    return result;
  }

  /// [dart growable performance](https://stackoverflow.com/questions/15943890/is-there-a-performance-benefit-in-using-fixed-length-lists-in-dart)
  List<R> m<R>(
    R Function(T value) convert, {
    bool growable = false,
  }) {
    final result = asMap()
        .map((index, value) {
          return MapEntry(
            index,
            convert(value),
          );
        })
        .values
        .toList(growable: growable);
    return result;
  }
}

extension HaloMap<K, V> on Map<K, V> {
  List<V> get v => values.toList();
  List<K> get k => keys.toList();

  List<R> indexMap<R>(
    R Function(K key, V value) convert, {
    bool growable = false,
  }) {
    final result = map((key, value) {
      return MapEntry(
        key,
        convert(key, value),
      );
    }).values.toList(growable: growable);
    return result;
  }

  Map<String, String> get allString {
    final Map<String, String> result = {};
    forEach((key, value) {
      final k = key.toString();
      final v = value.toString();
      result[k] = v;
    });
    return result;
  }

  Map<K, V> get withoutNull {
    Map<K, V> result = {};

    for (var key in keys) {
      if (this[key] != null) {
        result[key] = this[key] as V;
      }
    }

    return result;
  }
}

extension HLInt on int {
  Duration get ms {
    return Duration(milliseconds: this);
  }
}

extension HaloBool on bool {
  int get toInt {
    return this ? 1 : 0;
  }
}

extension HaloString on String {
  int get toInt {
    return int.parse(this);
  }

  // Use Extension
  String get breakWord {
    String breakWord = '';
    for (var element in runes) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    }
    return breakWord;
  }

  List<String> splitWithDelimiter(
    RegExp pattern, {
    bool combine = true,
  }) {
    final rawMatches = pattern.allMatchesWithSep(this);
    final List<String> result = [];
    // assert(result.length % 2 != 0);
    // for (var i = 0; i < result.length; i++) {}
    final headMatchDelim = rawMatches.length % 2 == 0;
    if (rawMatches.isEmpty) return [];
    assert(rawMatches.length >= 2);
    for (var i = 0; i < rawMatches.length; i++) {
      if (headMatchDelim) {
        if (i % 2 == 0) {
          result.add(rawMatches[i] + rawMatches[i + 1]);
        }
      } else {
        if (i == 0) {
          result.add(rawMatches[i]);
        } else if (i % 2 == 0) {
          result.add(rawMatches[i - 1] + rawMatches[i]);
        }
      }
    }
    return result;
  }
}

extension HaloRegExp on RegExp {
  List<String> allMatchesWithSep(String input, [int start = 0]) {
    var result = <String>[];
    for (var match in allMatches(input, start)) {
      result.add(input.substring(start, match.start));
      result.add(match[0]!);
      start = match.end;
    }
    result.add(input.substring(start));
    return result;
  }
}

Future<void> after(Duration duration, void Function() task) {
  return Future.delayed(duration, task);
}

Future<void> last(void Function()? task) {
  return Future.delayed(0.ms, task);
}

List<T> gen<T>({
  required int times,
  required T Function(int time) generator,
}) {
  List<T> list = [];
  for (var i = 0; i < times; i++) {
    list.add(generator(i));
  }
  return list;
}

final _rnd = Random();
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

int randomNumber(int length) {
  var next = _rnd.nextDouble() * pow(10, length);
  while (next < pow(10, length - 1)) {
    next *= 10;
  }
  return next.toInt();
}

String randomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
