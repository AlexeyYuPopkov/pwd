import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pwd/theme/common_size.dart';

typedef _TestHelper = ActionSheetTestHelper;

bool get _isMaterial => !(Platform.isIOS || Platform.isMacOS);

mixin ActionSheetHelper {
  void showActionSheet(
    BuildContext context, {
    String title = '',
    String message = '',
    required List<ActionSheetItemBuilder> items,
    ActionSheetItemBuilder? bottomItem,
  }) {
    if (_isMaterial) {
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          final theme = Theme.of(context);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(CommonSize.indent2x),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                if (message.isNotEmpty)
                  Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return item.build(context);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                ),
                if (bottomItem != null) const Divider(),
                if (bottomItem != null) bottomItem.build(context),
              ],
            ),
          );
        },
      );
    } else {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: title.isEmpty ? null : Text(title),
          message: message.isEmpty ? null : Text(message),
          actions: [
            for (final item in items) item.build(context),
          ],
          cancelButton: bottomItem?.build(context),
        ),
      );
    }
  }
}

final class ActionSheetItemBuilder {
  final String title;
  final String keyString;
  final ActionSheetItemType? type;
  final ValueChanged<BuildContext>? onTap;

  ActionSheetItemBuilder({
    required this.title,
    this.keyString = '',
    this.type,
    required this.onTap,
  });

  Widget build(BuildContext context) {
    if (_isMaterial) {
      final theme = Theme.of(context);
      return ListTile(
        key: keyString.isNotEmpty
            ? Key(_TestHelper.getItemKeyFor(keyString))
            : null,
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight:
                type == ActionSheetItemType.isDefault ? FontWeight.bold : null,
            color: type == ActionSheetItemType.isDestructive
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
          ),
        ),
        onTap: () {
          if (onTap != null) {
            onTap!(context);
          }
        },
      );
    } else {
      return CupertinoActionSheetAction(
        key: keyString.isNotEmpty
            ? Key(_TestHelper.getItemKeyFor(keyString))
            : null,
        isDefaultAction: type == ActionSheetItemType.isDefault,
        isDestructiveAction: type == ActionSheetItemType.isDestructive,
        onPressed: () {
          if (onTap != null) {
            onTap!(context);
          }
        },
        child: Text(title),
      );
    }
  }
}

enum ActionSheetItemType {
  isDefault,
  isDestructive,
}

final class ActionSheetTestHelper {
  static String getItemKeyFor(String keyString) => 'ActionSheet'
      '.$keyString'
      '.Key';
}
