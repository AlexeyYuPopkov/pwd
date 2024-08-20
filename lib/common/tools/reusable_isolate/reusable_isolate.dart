import 'dart:async';
import 'dart:isolate';

final class ReusableIsolate {
  static ReusableIsolate? _instance;
  Isolate? _isolate;
  late SendPort _sendPort;
  final _receivePort = ReceivePort();

  ReusableIsolate._();

  static FutureOr<ReusableIsolate> create() async {
    if (_instance == null) {
      final result = ReusableIsolate._();
      await result._start();
      _instance = result;
      return result;
    }

    return _instance!;
  }

  Future<R> performTask<P, R>(ReusableIsolateTask<P> task) async {
    final responsePort = ReceivePort();

    _sendPort.send(
      _Message(
        params: task,
        sendPort: responsePort.sendPort,
      ),
    );

    final result = await responsePort.first as R;
    responsePort.close();

    return result;
  }

  Future<void> dispose() async {
    _isolate?.kill(priority: Isolate.immediate);
    _receivePort.close();
    _isolate = null;
    _instance = null;
  }

  static Future<void> disposeIfPresent() async {
    _instance?._isolate?.kill(priority: Isolate.immediate);
    _instance?._receivePort.close();
    _instance?._isolate = null;
    _instance = null;
  }
}

// Private
extension on ReusableIsolate {
  Future<void> _start() async {
    _isolate = await Isolate.spawn(_isolateEntry, _receivePort.sendPort);
    _sendPort = await _receivePort.first;
  }

  static void _isolateEntry(SendPort sendPort) async {
    final receivePort = ReceivePort();

    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      final data = message as _Message;
      final params = data.params;
      final responsePort = data.sendPort;
      // final result = params.computation(params.params);

      switch (params) {
        case ReusableIsolateTaskSync():
          final result = params.computation(params.params);
          responsePort.send(result);
          break;
        case ReusableIsolateTaskAsync():
          params.computation(params.params).then((result) {
            responsePort.send(result);
          });
          // responsePort.send(result);
          break;
      }

      // responsePort.send(result);
    });
  }
}

final class _Message {
  final SendPort sendPort;
  final ReusableIsolateTask params;

  const _Message({
    required this.sendPort,
    required this.params,
  });
}

sealed class ReusableIsolateTask<T> {
  const ReusableIsolateTask();
  T get params;

  const factory ReusableIsolateTask.sync({
    required T params,
    required dynamic Function(T) computation,
  }) = ReusableIsolateTaskSync;

  const factory ReusableIsolateTask.async({
    required T params,
    required Future<dynamic> Function(T) computation,
  }) = ReusableIsolateTaskAsync;
}

final class ReusableIsolateTaskSync<T> extends ReusableIsolateTask<T> {
  @override
  final T params;
  final dynamic Function(T) computation;

  const ReusableIsolateTaskSync({
    required this.params,
    required this.computation,
  });
}

final class ReusableIsolateTaskAsync<T> extends ReusableIsolateTask<T> {
  @override
  final T params;
  final Future<dynamic> Function(T) computation;

  const ReusableIsolateTaskAsync({
    required this.params,
    required this.computation,
  });
}
