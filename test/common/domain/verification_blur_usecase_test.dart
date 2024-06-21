import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/app_lifecycle_listener_repository.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/biometric_repository.dart';
import 'package:pwd/common/domain/model/app_settings.dart';
import 'package:pwd/common/domain/usecases/get_settings_usecase.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/common/domain/usecases/verification_usecase.dart';
import 'package:rxdart/rxdart.dart';

class MockBiometricRepository extends Mock implements BiometricRepository {}

class MockAppLifecycleListenerRepository
    implements AppLifecycleListenerRepository {
  @override
  late final PublishSubject<bool> isActiveStream = PublishSubject();
}

class MockPinUsecase implements PinUsecase {
  List<BasePin> _results = [];

  List<BasePin> get results => _results;
  void setResults(List<BasePin> results) => _results = [...results];

  List<String> dropPinCalls = [];

  @override
  Future<void> dropPin() async {
    dropPinCalls.add('dropPin');
  }

  @override
  BasePin getPin() {
    return _results.removeAt(0);
  }

  @override
  Pin getPinOrThrow() => throw UnimplementedError();

  @override
  Stream<BasePin> get pinStream => throw UnimplementedError();

  @override
  Future<void> setPin(Pin pin) => throw UnimplementedError();
}

class MockGetSettingsUsecase implements GetSettingsUsecase {
  static const testDelay = Duration(milliseconds: 200);
  @override
  FutureOr<AppSettings> execute() => AppSettings(
        maxInactiveDuration: const Duration(milliseconds: 100),
      );
}

void main() {
  const maxTimeout = Timeout(Duration(seconds: 10));

  late BiometricRepository biometry;
  late MockAppLifecycleListenerRepository lifecycle;

  late MockPinUsecase pinUsecase;
  late VerificationUsecase sut;

  const pin = Pin(pinSha512: []);
  const emptyPin = BasePin.empty();
  const allow = Verification.allow();
  const processing = Verification.processing();
  const biometryRequest = BiometricRepositoryRequest(
    localizedReason: 'Unlock application',
  );

  setUp(
    () {
      biometry = MockBiometricRepository();
      lifecycle = MockAppLifecycleListenerRepository();
      pinUsecase = MockPinUsecase();

      sut = VerificationUsecase(
        biometricRepository: biometry,
        appLifecycleListenerRepository: lifecycle,
        pinUsecase: pinUsecase,
        settingsUsecase: MockGetSettingsUsecase(),
      );
    },
  );

  group(
    'VerificationBlurUsecase',
    () {
      test(
        'Auth state, app become active',
        () async {
          final expectedValues = [
            isA<Deny>(),
            allow,
          ];
          final expectedLength = expectedValues.length;
          int index = 0;

          pinUsecase.setResults([pin, pin]);

          sut.createStream(biometryRequest: biometryRequest).listen(
                expectAsync1(
                  (value) {
                    expect(value, expectedValues[index]);

                    index++;

                    if (index == expectedLength) {
                      expect(pinUsecase.results.length, 0);
                    }
                  },
                  count: expectedLength,
                ),
              );

          lifecycle.isActiveStream.sink.add(false);
          lifecycle.isActiveStream.sink.add(true);
        },
        timeout: maxTimeout,
      );

      test(
        'Not auth state, app become active',
        () async {
          final expectedValues = [
            allow,
          ];

          final expectedLength = expectedValues.length;
          int index = 0;

          pinUsecase.setResults([emptyPin, emptyPin]);

          sut.createStream(biometryRequest: biometryRequest).listen(
                expectAsync1(
                  (value) {
                    expect(value, expectedValues[index]);

                    index++;
                  },
                  count: expectedLength,
                ),
              );

          lifecycle.isActiveStream.sink.add(false);
          lifecycle.isActiveStream.sink.add(true);
        },
        timeout: maxTimeout,
      );

      test(
        'auth state, app become active when expired and pass biometry',
        () async {
          final expected = [
            isA<Deny>(),
            processing,
            allow,
          ];

          final expectedLength = expected.length;
          int index = 0;

          pinUsecase.setResults([pin, pin]);

          sut.createStream(biometryRequest: biometryRequest).listen(
                expectAsync1(
                  (e) {
                    expect(
                      e,
                      expected[index],
                    );

                    index++;

                    if (index == expectedLength) {
                      expect(pinUsecase.results.length, 0);
                    }
                  },
                  count: expectedLength,
                ),
              );

          lifecycle.isActiveStream.sink.add(false);

          await Future.delayed(MockGetSettingsUsecase.testDelay);

          lifecycle.isActiveStream.sink.add(true);

          when(
            () => biometry.execute(biometryRequest),
          ).thenAnswer((_) async => true);
        },
        timeout: maxTimeout,
      );

      test(
        'auth state, app become active when expired and fail biometry',
        () async {
          final expected = [
            isA<Deny>(),
            processing,
            isA<Deny>(),
          ];

          final expectedLength = expected.length;
          int index = 0;

          pinUsecase.setResults([pin, pin]);

          sut.createStream(biometryRequest: biometryRequest).listen(
                expectAsync1(
                  (e) {
                    expect(
                      e,
                      expected[index],
                    );

                    index++;

                    if (index == expectedLength) {
                      expect(pinUsecase.results.length, 0);
                      expect(pinUsecase.dropPinCalls[0], 'dropPin');
                    }
                  },
                  count: expectedLength,
                ),
              );

          lifecycle.isActiveStream.sink.add(false);

          await Future.delayed(MockGetSettingsUsecase.testDelay);

          lifecycle.isActiveStream.sink.add(true);

          when(
            () => biometry.execute(biometryRequest),
          ).thenAnswer((_) async => false);
        },
        timeout: maxTimeout,
      );

      test(
        'auth state, app become active when expired and pass biometry deny filter',
        () async {
          final expected = [
            isA<Deny>(),
            processing,
            allow,
          ];

          final expectedLength = expected.length;
          int index = 0;

          pinUsecase.setResults([pin, pin, pin]);

          sut.createStream(biometryRequest: biometryRequest).listen(
                expectAsync1(
                  (e) {
                    expect(
                      e,
                      expected[index],
                    );

                    index++;
                  },
                  count: expectedLength,
                ),
              );

          lifecycle.isActiveStream.sink.add(false);

          await Future.delayed(MockGetSettingsUsecase.testDelay);
          lifecycle.isActiveStream.sink.add(false);
          lifecycle.isActiveStream.sink.add(false);
          lifecycle.isActiveStream.sink.add(true);

          when(
            () => biometry.execute(biometryRequest),
          ).thenAnswer((_) async => true);
        },
        timeout: maxTimeout,
      );
    },
  );
}
