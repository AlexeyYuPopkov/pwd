abstract interface class ClockTimerUsecase {
  Stream<DateTime> get timerStream;
}

class ClockTimerUsecaseImpl implements ClockTimerUsecase {
  @override
  late final timerStream = Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  ).asBroadcastStream();
}
