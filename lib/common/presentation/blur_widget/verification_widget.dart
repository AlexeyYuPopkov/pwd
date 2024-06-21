import 'dart:ui';

import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pwd/common/domain/biometric_repository.dart';
import 'package:pwd/common/presentation/blur_widget/bloc/verification_bloc_state.dart';
import 'package:pwd/theme/common_theme.dart';

import 'bloc/verification_bloc.dart';

class VerificationWidget extends StatefulWidget {
  final Widget child;
  const VerificationWidget({super.key, required this.child});

  @override
  State<VerificationWidget> createState() => _VerificationWidgetState();
}

class _VerificationWidgetState extends State<VerificationWidget> {
  final layerLink = LayerLink();
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationBloc(
        biometricRequest: BiometricRepositoryRequest(
          localizedReason: context.biometricRequestReason,
        ),
        verificationUsecase: DiStorage.shared.resolve(),
      ),
      child: BlocConsumer<VerificationBloc, VerificationBlocState>(
        listener: _listener,
        buildWhen: (previous, current) => false,
        builder: (_, __) => widget.child,
      ),
    );
  }

  void _listener(BuildContext context, VerificationBlocState state) {
    switch (state) {
      case VisibleOverlayState():
        showOverlay();
        break;
      case HiddenOverlayState():
        hideOverLay();
        break;
    }
  }

  @override
  void dispose() {
    hideOverLay();
    super.dispose();
  }

  void showOverlay() {
    hideOverLay();

    final entry = OverlayEntry(
      builder: (context) {
        final maskColor = CommonTheme.of(context).maskColor;
        return CompositedTransformFollower(
          link: layerLink,
          offset: Offset.zero,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: ColoredBox(
              color: maskColor ?? Colors.transparent,
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(entry);
    overlayEntry = entry;
  }

  void toggleOverLay() {
    overlayEntry == null ? showOverlay() : hideOverLay();
  }

  void hideOverLay() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
  }
}

extension on BuildContext {
  String get biometricRequestReason => 'Unlock application';
}
