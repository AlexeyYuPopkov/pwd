import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/biometric_repository.dart';
import 'package:pwd/common/domain/usecases/verification_usecase.dart';
import 'package:pwd/common/presentation/blur_widget/bloc/verification_bloc_event.dart';
import 'package:rxdart/rxdart.dart';

import 'verification_bloc_state.dart';

final class VerificationBloc
    extends Bloc<VerificationBlocEvent, VerificationBlocState> {
  final BiometricRepositoryRequest biometricRequest;
  final VerificationUsecase verificationUsecase;

  late final Stream<Verification> verificationUsecaseStream =
      verificationUsecase.createStream(
    biometryRequest: biometricRequest,
  );
  late final StreamSubscription stateStreamSubscription;

  VerificationBloc({
    required this.biometricRequest,
    required this.verificationUsecase,
  }) : super(
          const VerificationBlocState.hidden(),
        ) {
    _setupHandlers();
    _setupSubscriptions();
  }

  @override
  Future<void> close() {
    stateStreamSubscription.cancel();
    return super.close();
  }

  void _setupHandlers() {
    on<ShowOverlayEvent>(_onShowOverlayEvent);
    on<HideOverlayEvent>(_onHideOverlayEvent);
  }

  void _setupSubscriptions() {
    stateStreamSubscription = verificationUsecaseStream
        .debounceTime(
      Durations.short4,
    )
        .listen(
      (e) {
        _onStateChanged(e);
      },
    );
  }

  void _onShowOverlayEvent(
    ShowOverlayEvent event,
    Emitter<VerificationBlocState> emit,
  ) =>
      emit(
        const VerificationBlocState.visible(),
      );

  void _onHideOverlayEvent(
    HideOverlayEvent event,
    Emitter<VerificationBlocState> emit,
  ) =>
      emit(
        const VerificationBlocState.hidden(),
      );

  void _onStateChanged(Verification status) {
    switch (status) {
      case Allow():
        add(const VerificationBlocEvent.hide());
      case Deny():
        add(const VerificationBlocEvent.show());
      case Processing():
        break;
    }
  }
}
