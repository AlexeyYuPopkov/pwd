import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pwd/common/domain/app_lifecycle_listener_repository.dart';

final class AppLifecycleListenerDatasource
    implements AppLifecycleListenerRepository {
  final _isActiveStream = PublishSubject<bool>();

  late final AppLifecycleListener appLifecycleListener;

  AppLifecycleListenerDatasource() {
    appLifecycleListener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
  }

  void _onStateChanged(AppLifecycleState state) {
    _isActiveStream.sink.add(state.isActive);
  }

  @override
  Stream<bool> get isActiveStream => _isActiveStream;
}

extension on AppLifecycleState {
  bool get isActive {
    switch (this) {
      case AppLifecycleState.resumed:
        return true;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return false;
    }
  }
}
