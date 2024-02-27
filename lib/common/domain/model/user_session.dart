import 'package:equatable/equatable.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configurations.dart';

sealed class UserSession extends Equatable {
  const UserSession();
}

final class UnconfiguredSession extends UserSession {
  const UnconfiguredSession();

  @override
  List<Object?> get props => [];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || runtimeType == other.runtimeType;

  @override
  int get hashCode => Object.hashAll({runtimeType});
}

final class UnauthorizedSession extends UserSession {
  final RemoteConfigurations appConfiguration;
  const UnauthorizedSession({
    required this.appConfiguration,
  });

  @override
  List<Object?> get props => [appConfiguration];
}

final class ValidSession extends UserSession {
  final RemoteConfigurations appConfiguration;
  final Pin pin;

  const ValidSession({
    required this.appConfiguration,
    required this.pin,
  });

  @override
  List<Object?> get props => [appConfiguration, pin];
}
