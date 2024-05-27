import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/presentation/common_highlighted_row.dart';
import 'package:pwd/theme/common_size.dart';
import 'package:pwd/theme/common_theme.dart';

import 'configurations_screen_reorder_icon_part.dart';

class ConfigurationScreenConfigItem extends StatelessWidget {
  final RemoteConfiguration item;
  final ValueChanged<RemoteConfiguration> onTap;

  const ConfigurationScreenConfigItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final commonTheme = CommonTheme.of(context);
    return CommonHighlightedBackgroundRow(
      highlightedColor: commonTheme.highlightColor,
      child: Padding(
        padding: const EdgeInsets.all(CommonSize.indentVariant2x),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: CommonSize.indentVariant2x,
                bottom: CommonSize.indentVariant2x,
                right: CommonSize.indentVariant2x,
              ),
              child: ConfigurationsScreenReorderIcon(item: item),
            ),
            Expanded(
              child: IgnorePointer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemTitle(context),
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.itemDescription(context),
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: CommonSize.indent),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
      onTap: () {
        onTap(item);
      },
    );
  }
}

extension on RemoteConfiguration {
  String itemTitle(BuildContext context) => fileName;

  String itemDescription(BuildContext context) {
    switch (type) {
      case ConfigurationType.git:
        return 'Synchronization with Git API';
      case ConfigurationType.googleDrive:
        return 'Synchronization with Google Drive API';
    }
  }
}
