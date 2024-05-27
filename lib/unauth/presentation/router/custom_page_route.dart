import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class CustomPageRoute<T> extends PageRoute<T>
    with CustomRouteTransitionMixin<T> {
  /// Construct a MaterialPageRoute whose contents are defined by [builder].
  CustomPageRoute({
    required this.builder,
    required this.theme,
    this.transitionDuration = Durations.medium2,
    super.settings,
    this.maintainState = true,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
  }) {
    assert(opaque);
  }

  @override
  final PageTransitionsTheme? theme;

  @override
  final Duration transitionDuration;

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  final bool maintainState;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

final class FadeTransitionBuilder implements PageTransitionsBuilder {
  const FadeTransitionBuilder();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween(begin: 0.0, end: 1.0).chain(
      CurveTween(curve: Curves.ease),
    );
    return FadeTransition(
      opacity: animation.drive(tween),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}

mixin CustomRouteTransitionMixin<T> on PageRoute<T> {
  PageTransitionsTheme? get theme;

  /// Builds the primary contents of the route.
  @protected
  Widget buildContent(BuildContext context);

  @override
  Duration get transitionDuration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return (nextRoute is MaterialRouteTransitionMixin &&
            !nextRoute.fullscreenDialog) ||
        (nextRoute is CupertinoRouteTransitionMixin &&
            !nextRoute.fullscreenDialog) ||
        (nextRoute is CustomRouteTransitionMixin) &&
            !nextRoute.fullscreenDialog;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: buildContent(context),
      );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      (theme ?? Theme.of(context).pageTransitionsTheme).buildTransitions<T>(
        this,
        context,
        animation,
        secondaryAnimation,
        child,
      );
}
