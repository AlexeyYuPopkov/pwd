import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/domain/clock_configuration_provider.dart';
import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:pwd/common/domain/usecases/clock_usecase.dart';

sealed class ClocksResult {
  const ClocksResult();
}

final class ResultError extends ClocksResult {
  final Object error;

  const ResultError(this.error);
}

final class ResultSuccess extends ClocksResult {
  final List<ClockModel> result;

  const ResultSuccess(this.result);
}

final class ClockConfigurationProviderMock
    implements ClockConfigurationProvider {
  late final List<Future<ClocksResult>> clocksAnswers;
  late final List setClocksAnswers;
  late List<String> order = [];

  void whenClocksAnswers(List<Future<ClocksResult>> answers) {
    clocksAnswers = answers;
  }

  void whenSetClocksAnswers(List<Future<void>> answers) {
    setClocksAnswers = [Future.value()];
  }

  @override
  Future<List<ClockModel>> get clocks async {
    order.add('clocks');
    final resultFuture = clocksAnswers.removeAt(0);
    final result = await resultFuture;
    switch (result) {
      case ResultError():
        throw result.error;
      case ResultSuccess():
        return result.result;
    }
  }

  @override
  Future<void> setClocks(List<ClockModel> clocks) {
    order.add('setClocks');
    return setClocksAnswers.removeAt(0);
  }
}

void main() {
  group('ClockUsecase', () {
    late ClockConfigurationProviderMock configurationProvider;
    late ClockUsecase usecase;

    setUp(() {
      configurationProvider = ClockConfigurationProviderMock();
      usecase = ClockUsecase(clockConfigurationProvider: configurationProvider);
    });

    test('get clocks when not saved.', () async {
      configurationProvider.whenClocksAnswers([
        Future.value(const ResultSuccess([])),
      ]);

      final clocks = await usecase.getClocks();

      expect(configurationProvider.order, ['clocks']);

      expect(clocks.length, 1);

      final now = DateTime.now();

      expect(clocks.first.timeZoneOffset, now.timeZoneOffset);
    });

    test('get clocks and throw.', () async {
      configurationProvider.whenClocksAnswers([
        Future.value(const ResultError(_TestError())),
      ]);

      final clocks = await usecase.getClocks();

      expect(configurationProvider.order, ['clocks']);

      expect(clocks.length, 1);

      final now = DateTime.now();

      expect(clocks.first.timeZoneOffset, now.timeZoneOffset);

      // expect(() => usecase.getClocks(), throwsA(isA<_TestError>()));
      // expect(configurationProvider.order, ['clocks']);
    });

    test('add clock.', () async {
      const existingClock = ClockModel(
        id: '1',
        label: 'label1',
        timeZoneOffset: Duration(hours: 2),
      );

      const newClock = ClockModel(
        id: '2',
        label: 'label2',
        timeZoneOffset: Duration(hours: 3),
      );

      configurationProvider.whenClocksAnswers([
        Future.value(const ResultSuccess([existingClock])),
        Future.value(const ResultSuccess([existingClock, newClock])),
      ]);

      configurationProvider.whenSetClocksAnswers([Future.value()]);

      final result = await usecase.changedWithClock(newClock);

      expect(result.length, 2);

      expect(result[0], existingClock);
      expect(result[1], newClock);

      expect(configurationProvider.order, [
        'clocks',
        'setClocks',
        'clocks',
      ]);
    });

    test('delete clock.', () async {
      const clock1 = ClockModel(
        id: '1',
        label: 'label1',
        timeZoneOffset: Duration(hours: 2),
      );

      const clock2 = ClockModel(
        id: '2',
        label: 'label2',
        timeZoneOffset: Duration(hours: 3),
      );

      const clock3 = ClockModel(
        id: '3',
        label: 'label3',
        timeZoneOffset: Duration(hours: 4),
      );

      configurationProvider.whenClocksAnswers([
        Future.value(const ResultSuccess([clock1, clock2, clock3])),
        Future.value(const ResultSuccess([clock1, clock3])),
      ]);

      configurationProvider.whenSetClocksAnswers([Future.value()]);

      final result = await usecase.byClockDeletion(clock2);

      expect(result.length, 2);

      expect(result[0], clock1);
      expect(result[1], clock3);

      expect(configurationProvider.order, [
        'clocks',
        'setClocks',
        'clocks',
      ]);
    });
  });
}

final class _TestError {
  const _TestError();
}
