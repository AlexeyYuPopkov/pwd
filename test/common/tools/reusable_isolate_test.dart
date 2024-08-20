import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/tools/reusable_isolate/reusable_isolate.dart';

final class _Methods {
  static dynamic heavyComputation1(dynamic number) {
    io.sleep(Durations.medium1);
    return number * 2;
  }

  static dynamic heavyComputation2(dynamic number) {
    io.sleep(Durations.short2);
    return number * 2;
  }

  static dynamic heavyComputation3(dynamic number) {
    return (number * 2).toString();
  }

  static dynamic heavyComputation4(dynamic str) {
    return int.parse(str) * 2;
  }

//
  static Future<dynamic> heavyComputationAsync1(dynamic number) async {
    await Future.delayed(Durations.medium1);
    return number * 2;
  }

  static Future<dynamic> heavyComputationAsync2(dynamic number) async {
    await Future.delayed(Durations.short2);
    return number * 2;
  }

  static Future<dynamic> heavyComputationAsync3(dynamic number) async {
    return (number * 2).toString();
  }

  static Future<dynamic> heavyComputationAsync4(dynamic str) async {
    return int.parse(str) * 2;
  }
}

main() {
  late ReusableIsolate sut;

  setUp(
    () async {
      sut = await ReusableIsolate.create();
    },
  );

  tearDown(
    () {
      sut.dispose();
    },
  );

  group(
    'IsolateHandler',
    () {
      test(
        'In sequence',
        () async {
          final result1 = await sut.performTask(
            const ReusableIsolateTask<int>.sync(
              params: 10,
              computation: _Methods.heavyComputation1,
            ),
          );
          final result2 = await sut.performTask(
            const ReusableIsolateTask<int>.sync(
              params: 20,
              computation: _Methods.heavyComputation2,
            ),
          );
          final result3 = await sut.performTask(
            const ReusableIsolateTask<int>.sync(
              params: 30,
              computation: _Methods.heavyComputation3,
            ),
          );

          final result4 = await sut.performTask(
            const ReusableIsolateTask<String>.sync(
              params: '40',
              computation: _Methods.heavyComputation4,
            ),
          );

          expect(result1, 20);
          expect(result2, 40);
          expect(result3, '60');
          expect(result4, 80);
        },
      );

      test(
        'Simultaneously',
        () async {
          final results = await Future.wait([
            sut.performTask(
              const ReusableIsolateTask<int>.sync(
                params: 10,
                computation: _Methods.heavyComputation1,
              ),
            ),
            sut.performTask(
              const ReusableIsolateTask<int>.sync(
                params: 20,
                computation: _Methods.heavyComputation2,
              ),
            ),
            sut.performTask(
              const ReusableIsolateTask<int>.sync(
                params: 30,
                computation: _Methods.heavyComputation3,
              ),
            ),
            sut.performTask(
              const ReusableIsolateTask<String>.sync(
                params: '40',
                computation: _Methods.heavyComputation4,
              ),
            )
          ]);

          expect(results[0], 20);
          expect(results[1], 40);
          expect(results[2], '60');
          expect(results[3], 80);
        },
      );
    },
  );

  group(
    'IsolateHandler',
    () {
      test(
        'In sequence',
        () async {
          final result1 = await sut.performTask(
            const ReusableIsolateTask<int>.async(
              params: 10,
              computation: _Methods.heavyComputationAsync1,
            ),
          );
          final result2 = await sut.performTask(
            const ReusableIsolateTask<int>.async(
              params: 20,
              computation: _Methods.heavyComputationAsync2,
            ),
          );
          final result3 = await sut.performTask(
            const ReusableIsolateTask<int>.async(
              params: 30,
              computation: _Methods.heavyComputationAsync3,
            ),
          );

          final result4 = await sut.performTask(
            const ReusableIsolateTask<String>.async(
              params: '40',
              computation: _Methods.heavyComputationAsync4,
            ),
          );

          expect(result1, 20);
          expect(result2, 40);
          expect(result3, '60');
          expect(result4, 80);
        },
      );

      test(
        'Simultaneously async',
        () async {
          final results = await Future.wait([
            sut.performTask(
              const ReusableIsolateTask<int>.async(
                params: 10,
                computation: _Methods.heavyComputationAsync1,
              ),
            ),
            sut.performTask(
              const ReusableIsolateTask<int>.async(
                params: 20,
                computation: _Methods.heavyComputationAsync2,
              ),
            ),
            sut.performTask(
              const ReusableIsolateTask<int>.async(
                params: 30,
                computation: _Methods.heavyComputationAsync3,
              ),
            ),
            sut.performTask(
              const ReusableIsolateTask<String>.async(
                params: '40',
                computation: _Methods.heavyComputationAsync4,
              ),
            )
          ]);

          expect(results[0], 20);
          expect(results[1], 40);
          expect(results[2], '60');
          expect(results[3], 80);
        },
      );
    },
  );
}
