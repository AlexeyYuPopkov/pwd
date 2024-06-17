import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/presentation/clock/clock_widget.dart';
import 'package:pwd/common/presentation/clock/clock_widget24.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/clocks_widget_test_helper.dart';
import 'package:pwd/l10n/localization_helper.dart';
import 'package:pwd/theme/common_size.dart';
import 'package:pwd/theme/common_theme.dart';

final class ClockItemWidget extends StatefulWidget {
  static const horizontalPadding = CommonSize.indent2x;

  final ClockModel clock;
  final TimeFormatter formatter;
  final Stream<DateTime> timerStream;
  final VoidCallback onEdit;
  final VoidCallback onAppend;
  final VoidCallback onDelete;

  const ClockItemWidget({
    super.key,
    required this.clock,
    required this.formatter,
    required this.timerStream,
    required this.onEdit,
    required this.onAppend,
    required this.onDelete,
  });

  @override
  State<ClockItemWidget> createState() => _ClockItemWidgetState();
}

final class _ClockItemWidgetState extends State<ClockItemWidget> {
  late final _overlayKey = GlobalKey<_ClockItemOwerlayMenuState>();

  void _tooggleOverlay() {
    _overlayKey.currentState?.toggleOverLay();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _tooggleOverlay,
      onDoubleTap: _tooggleOverlay,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ClockItemWidget.horizontalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.clock.label.isNotEmpty
                  ? widget.clock.label
                  : widget.formatter.formattedTimeZoneOffsetOffset(
                      offset: widget.clock.timeZoneOffset,
                    ),
            ),
            const SizedBox(height: CommonSize.indent),
            Stack(
              children: [
                ClockWidget(
                  formatter: widget.formatter,
                  parameters: widget.clock,
                  timerStream: widget.timerStream,
                  onLongTap: null,
                ),
                Positioned.fill(
                  child: ClockItemOwerlayMenu(
                    key: _overlayKey,
                    onEdit: widget.onEdit,
                    onAppend: widget.onAppend,
                    onDelete: widget.onDelete,
                  ),
                ),
              ],
            ),
            const SizedBox(height: CommonSize.indent),
            ClockWidget24(
              formatter: widget.formatter,
              parameters: widget.clock,
              timerStream: widget.timerStream,
            ),
          ],
        ),
      ),
    );
  }
}

final class ClockItemOwerlayMenu extends StatefulWidget {
  final VoidCallback onEdit;
  final VoidCallback onAppend;
  final VoidCallback onDelete;

  const ClockItemOwerlayMenu({
    super.key,
    required this.onEdit,
    required this.onAppend,
    required this.onDelete,
  });

  @override
  State<ClockItemOwerlayMenu> createState() => _ClockItemOwerlayMenuState();
}

final class _ClockItemOwerlayMenuState extends State<ClockItemOwerlayMenu> {
  static const menuWidth = 200.0;
  OverlayEntry? overlayEntry;
  final layerLink = LayerLink();
  Size? _widgetSize;

  void setWidgetSize(Size size) {
    if (_widgetSize != size) {
      _widgetSize = size;
      hideOverLay();
    }
  }

  @override
  void dispose() {
    hideOverLay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: LayoutBuilder(builder: (context, constraints) {
        setWidgetSize(
          Size(constraints.minWidth, constraints.maxHeight),
        );
        return CompositedTransformTarget(
          link: layerLink,
          child: const SizedBox(),
        );
      }),
    );
  }

  void showOverlay() {
    hideOverLay();
    final renderBox = context.findRenderObject() as RenderBox;

    final size = Size(
      menuWidth,
      renderBox.size.height + CommonSize.indent4x,
    );

    final entry = OverlayEntry(
      builder: (context) {
        final maskColor = CommonTheme.of(context).maskColor;
        final menuOffsetX = _calculateMenuxOffset(
          context,
          renderBox: renderBox,
        );

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: hideOverLay,
                child: Container(color: maskColor),
              ),
            ),
            CompositedTransformFollower(
              link: layerLink,
              offset: Offset(menuOffsetX, size.height),
              child: SizedBox(
                width: menuWidth,
                child: ClockItemOwerlayMenuContent(
                  onEdit: () {
                    widget.onEdit();
                    hideOverLay();
                  },
                  onAppend: () {
                    widget.onAppend();
                    hideOverLay();
                  },
                  onDelete: () {
                    widget.onDelete();
                    hideOverLay();
                  },
                ),
              ),
            ),
          ],
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

  double _calculateMenuxOffset(
    BuildContext context, {
    required RenderBox renderBox,
  }) {
    // final screenSize = MediaQuery.sizeOf(context);
    // final globalMenuOffset = renderBox.localToGlobal(Offset.zero);

    var menuOffsetX = -(menuWidth - renderBox.size.width) / 2.0;

    // menuOffsetX = globalMenuOffset.dx > screenSize.width - menuWidth
    //     ? renderBox.size.width - menuWidth
    //     : menuOffsetX;

    // menuOffsetX = globalMenuOffset.dx <= -menuOffsetX ? 0.0 : menuOffsetX;

    return menuOffsetX;
  }
}

final class ClockItemOwerlayMenuContent extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onAppend;
  final VoidCallback onDelete;

  const ClockItemOwerlayMenuContent({
    super.key,
    required this.onEdit,
    required this.onAppend,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(CommonSize.cornerRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ButtonWidget(
            key: Key(ClocksWidgetTestHelper.clockWidgetEditButtonKey),
            title: context.editButtonText,
            onTap: onEdit,
          ),
          const Divider(height: CommonSize.thickness),
          _ButtonWidget(
            key: Key(ClocksWidgetTestHelper.clockWidgetAddButtonKey),
            title: context.appendButtonText,
            onTap: onAppend,
          ),
          const Divider(height: CommonSize.thickness),
          _ButtonWidget(
            key: Key(ClocksWidgetTestHelper.clockWidgetDeleteButtonKey),
            title: context.deleteButtonText,
            errorStyle: true,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

final class _ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool errorStyle;

  const _ButtonWidget({
    super.key,
    required this.title,
    this.errorStyle = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = errorStyle
        ? theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
          )
        : theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
          );

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: CommonSize.indent),
      onPressed: onTap,
      child: Text(
        title,
        style: textStyle,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }
}

extension on BuildContext {
  String get editButtonText => localization.commonEdit;
  String get appendButtonText => localization.commonAppend;
  String get deleteButtonText => localization.commonDelete;
}
