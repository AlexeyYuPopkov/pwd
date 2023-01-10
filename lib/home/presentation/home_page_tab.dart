import 'package:flutter/material.dart';
import 'package:pwd/notes/presentation/router/main_router_delegate.dart';
import 'package:pwd/settings/presentation/router/settings_router_delegate.dart';

abstract class TabbarTabModel {
  TabbarTabModel();

  String title(BuildContext context);
  IconData get icon;

  Widget get body;
}

class HomeTab extends TabbarTabModel {
  HomeTab();

  @override
  IconData get icon => Icons.home;

  @override
  String title(BuildContext context) => 'Home';

  @override
  late final Widget body = TabWrapper(
    child: Router(
      routerDelegate: MainRouterDelegate(),
    ),
  );
}

class SettingsTab extends TabbarTabModel {
  SettingsTab();

  @override
  IconData get icon => Icons.settings;

  @override
  String title(BuildContext context) => 'Settings';

  @override
  late final Widget body = TabWrapper(
    child: Router(
      routerDelegate: SettingsRouterDelegate(),
    ),
  );
}

class TabWrapper extends StatefulWidget {
  final Widget child;

  const TabWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<TabWrapper> createState() => _TabWrapperState();
}

class _TabWrapperState extends State<TabWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
