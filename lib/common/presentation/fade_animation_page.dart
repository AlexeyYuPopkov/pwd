import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FadeAnimationPage extends Page implements Equatable {
  final Widget child;

  const FadeAnimationPage({
    super.key,
    required this.child,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var curveTween = CurveTween(curve: Curves.easeIn);

        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }

  @override
  List<Object?> get props => [name, arguments, child.runtimeType];

  @override
  bool? get stringify => null;
}
