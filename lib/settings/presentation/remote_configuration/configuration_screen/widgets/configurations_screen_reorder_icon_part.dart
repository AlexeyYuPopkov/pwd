part of '../configurations_screen.dart';

final class _ReorderIcon extends StatefulWidget {
  final RemoteConfiguration item;

  const _ReorderIcon({required this.item});

  @override
  State<_ReorderIcon> createState() => _ReorderIconState();
}

final class _ReorderIconState extends State<_ReorderIcon>
    with SingleTickerProviderStateMixin {
  static const duration = Durations.medium2;
  late final _tween = Tween<double>(begin: 0.0, end: pi);
  late final _controller = AnimationController(duration: duration, vsync: this);
  late final _animation = _controller.drive(_tween);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          _controller.reset();
          _controller.animateTo(_tween.end as double);
        },
        child: _AnimatedIcon(
          animation: _animation,
          child: Icon(
            Icons.reorder,
            key: Key(
              _TestHelper.getReorderIconKeyFor(widget.item.id),
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
