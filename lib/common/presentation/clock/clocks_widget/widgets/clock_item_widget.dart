import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/clock_model.dart';
import 'package:pwd/common/domain/time_formatter/time_formatter.dart';
import 'package:pwd/common/presentation/clock/clock_widget.dart';
import 'package:pwd/common/presentation/clock/clock_widget24.dart';
import 'package:pwd/common/presentation/clock/clocks_widget/clocks_widget_test_helper.dart';
import 'package:pwd/theme/common_size.dart';

class ClockItemWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CommonSize.indent2x,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            clock.label.isNotEmpty
                ? clock.label
                : formatter.formattedTimeZoneOffsetOffset(
                    offset: clock.timeZoneOffset,
                  ),
          ),
          const SizedBox(height: CommonSize.indent),
          Stack(
            children: [
              ClockWidget(
                formatter: formatter,
                parameters: clock,
                timerStream: timerStream,
                onLongTap: null,
              ),
              Positioned.fill(
                child: ClockItemOwerlayMenu(
                  onEdit: onEdit,
                  onAppend: onAppend,
                  onDelete: onDelete,
                ),
              ),
            ],
          ),
          const SizedBox(height: CommonSize.indent),
          ClockWidget24(
            formatter: formatter,
            parameters: clock,
            timerStream: timerStream,
          ),
        ],
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

class _ClockItemOwerlayMenuState extends State<ClockItemOwerlayMenu> {
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
    return GestureDetector(
      onLongPress: toggleOverLay,
      onDoubleTap: toggleOverLay,
      child: ColoredBox(
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
      ),
    );
  }

  void showOverlay() {
    hideOverLay();
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final entry = OverlayEntry(
      builder: (context) {
        final maskColor =
            Theme.of(context).colorScheme.background.withOpacity(0.5);
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => hideOverLay(),
                child: Container(color: maskColor),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height,
              width: size.width,
              child: CompositedTransformFollower(
                link: layerLink,
                offset: Offset(0, size.height),
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
    const rowHeight = CommonSize.indent4x;
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.primary,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius:
            const BorderRadius.all(Radius.circular(CommonSize.cornerRadius)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            key: Key(ClocksWidgetTestHelper.clockWidgetEditButtonKey),
            padding: EdgeInsets.zero,
            onPressed: onEdit,
            child: SizedBox(
              height: rowHeight,
              child: Center(
                child: Text(
                  context.editButtonText,
                  style: textStyle,
                ),
              ),
            ),
          ),
          const Divider(
            height: CommonSize.thickness,
          ),
          CupertinoButton(
            key: Key(ClocksWidgetTestHelper.clockWidgetAddButtonKey),
            padding: EdgeInsets.zero,
            onPressed: onAppend,
            child: SizedBox(
              height: rowHeight,
              child: Center(
                child: Text(
                  context.appendButtonText,
                  style: textStyle,
                ),
              ),
            ),
          ),
          const Divider(
            height: CommonSize.thickness,
          ),
          CupertinoButton(
            key: Key(ClocksWidgetTestHelper.clockWidgetDeleteButtonKey),
            padding: EdgeInsets.zero,
            onPressed: onDelete,
            child: SizedBox(
              height: rowHeight,
              child: Center(
                child: Text(
                  context.deleteButtonText,
                  style: textStyle?.copyWith(color: theme.colorScheme.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on BuildContext {
  String get editButtonText => 'Edit';
  String get appendButtonText => 'Append';
  String get deleteButtonText => 'Delete';
}
