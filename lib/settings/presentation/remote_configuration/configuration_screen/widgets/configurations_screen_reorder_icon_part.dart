import 'dart:math' show pi, sin, cos;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/settings/presentation/remote_configuration/configuration_screen/configurations_screen_test_helper.dart';
import 'package:pwd/theme/common_size.dart';

final class ConfigurationsScreenReorderIcon extends StatefulWidget {
  final RemoteConfiguration item;

  const ConfigurationsScreenReorderIcon({super.key, required this.item});

  @override
  State<ConfigurationsScreenReorderIcon> createState() =>
      _ConfigurationsScreenReorderIconState();
}

final class _ConfigurationsScreenReorderIconState
    extends State<ConfigurationsScreenReorderIcon>
    with SingleTickerProviderStateMixin {
  static const duration = Durations.medium2;
  late final _tween = Tween<double>(begin: 0.0, end: pi);
  late final _controller = AnimationController(duration: duration, vsync: this);
  late final _animation = _controller.drive(_tween);

  @override
  Widget build(BuildContext context) => CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: CommonSize.zero,
        onPressed: () {
          _controller.reset();
          _controller.animateTo(_tween.end as double);
        },
        child: _AnimatedIcon(
          animation: _animation,
          child: Icon(
            Icons.reorder,
            key: Key(
              ConfigurationsScreenTestHelper.getReorderIconKeyFor(
                widget.item.id,
              ),
            ),
          ),
        ),
      );
}

final class _AnimatedIcon extends AnimatedWidget {
  final Widget _child;

  const _AnimatedIcon({
    required Widget child,
    required Animation<double> animation,
  })  : _child = child,
        super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    final sinus = sin(animation.value);
    final cosinus = cos(animation.value);
    return Transform.translate(
      offset: Offset(
        (-sinus * sinus) * 10,
        (sinus * cosinus) * 10,
      ),
      child: _child,
    );
  }
}
