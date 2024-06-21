import 'dart:async';

import 'package:pwd/common/domain/app_lifecycle_listener_repository.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/biometric_repository.dart';
import 'package:pwd/common/domain/usecases/get_settings_usecase.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:rxdart/rxdart.dart';

final class VerificationUsecase {
  final BiometricRepository biometricRepository;
  final AppLifecycleListenerRepository appLifecycleListenerRepository;
  final PinUsecase pinUsecase;
  final GetSettingsUsecase settingsUsecase;

  late final _userInitiated = PublishSubject<Verification>();

  DateTime? _deniedAt;

  void setDeniedAtIfNeeded() {
    // ignore: prefer_conditional_assignment
    if (_deniedAt == null) {
      _deniedAt = DateTime.now();
    }
  }

  void resetDenyTime() => _deniedAt = null;

  VerificationUsecase({
    required this.biometricRepository,
    required this.appLifecycleListenerRepository,
    required this.pinUsecase,
    required this.settingsUsecase,
  });

  Stream<Verification> createStream({
    required BiometricRepositoryRequest biometryRequest,
  }) {
    return Rx.merge(
      [
        appLifecycleListenerRepository.isActiveStream.distinct().map(
          (isActive) {
            final pin = pinUsecase.getPin();
            switch (pin) {
              case Pin():
                return isActive
                    ? const Verification.allow()
                    : const Verification.deny();
              case EmptyPin():
                return const Verification.allow();
            }
          },
        ).distinct((a, b) => a.runtimeType == b.runtimeType),
        _userInitiated,
      ],
    ).asyncMap(
      (e) async {
        if (e is Deny) {
          setDeniedAtIfNeeded();
        }

        return await _performAuthorizationIfNeeded(
          currentStatus: e,
          biometryRequest: biometryRequest,
        );
      },
    );
  }

  Future<Verification> _performAuthorizationIfNeeded({
    required Verification currentStatus,
    required BiometricRepositoryRequest biometryRequest,
  }) async {
    final denyTime = _deniedAt;

    if (currentStatus is Allow && denyTime != null) {
      if (await _isOutdated(denyTime: denyTime)) {
        _passBiometry(biometricRequest: biometryRequest);
        return const Verification.processing();
      } else {
        return currentStatus;
      }
    } else {
      return currentStatus;
    }
  }

  FutureOr<bool> _isOutdated({required DateTime denyTime}) async {
    final settings = await settingsUsecase.execute();
    return denyTime
        .add(
          settings.maxInactiveDuration,
        )
        .isBefore(
          DateTime.now(),
        );
  }

  void _passBiometry({
    required BiometricRepositoryRequest biometricRequest,
  }) async {
    try {
      final isAuthorized = await biometricRepository.execute(biometricRequest);

      if (isAuthorized) {
        _userInitiated.sink.add(const Verification.allow());
      } else {
        _userInitiated.sink.add(const Verification.deny());
        await pinUsecase.dropPin();
      }
    } catch (e) {
      await pinUsecase.dropPin();
      _userInitiated.sink.add(const Verification.allow());
    } finally {
      resetDenyTime();
    }
  }
}

// Verification
sealed class Verification {
  const Verification();

  const factory Verification.allow() = Allow;

  const factory Verification.deny() = Deny;

  const factory Verification.processing() = Processing;
}

final class Allow extends Verification {
  const Allow();
}

final class Deny extends Verification {
  const Deny();
}

final class Processing extends Verification {
  const Processing();
}
