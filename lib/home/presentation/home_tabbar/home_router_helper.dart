import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pwd/common/domain/remote_configuration_provider.dart';
import 'package:pwd/home/presentation/configuration_undefined_screen/configuration_undefined_screen.dart';
import 'package:pwd/home/presentation/home_tabbar/bloc/home_folders_bloc.dart';
import 'package:pwd/home/presentation/home_tabbar/folder_model.dart';
import 'package:pwd/notes/presentation/router/notes_router_helper.dart';
import 'package:pwd/settings/presentation/router/settings_router_helper.dart';
import 'package:pwd/theme/custom_page_transistions_theme.dart';
import 'package:pwd/unauth/presentation/router/custom_page_route.dart';
import 'package:pwd/unauth/presentation/router/path_parameters.dart';
import 'package:pwd/unauth/presentation/router/redirect_to_login_page_helper.dart';
import 'bloc/home_folders_bloc_event.dart';
import 'bloc/home_folders_bloc_state.dart';
import 'home_screen.dart';

final class HomeRouterHelper with RedirectToLoginPageHelper {
  @override
  final bool Function() isAuthorized;

  RemoteConfigurationProvider get remoteConfigurationsProvider =>
      DiStorage.shared.resolve();

  late final settingsRouterHelper = SettingsRouterHelper(
    isAuthorized: isAuthorized,
  );

  late final notesRouterHelper = NotesRouterHelper(
    isAuthorized: isAuthorized,
  );

  HomeRouterHelper({required this.isAuthorized});

  late final route = [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return BlocProvider(
          key: const Key('HomeTabbarBloc'),
          create: (context) => HomeFoldersBloc(
            remoteConfigurationsProvider: remoteConfigurationsProvider,
            pinUsecase: DiStorage.shared.resolve(),
          ),
          child: BlocConsumer<HomeFoldersBloc, HomeFoldersBlocState>(
            listener: (context, state) {
              if (state.data.folders.isEmpty) {
                context.go(HomeRouterUndefinedTabPath.goPath());
              } else {
                final tab = state.data.folders[state.data.index];

                switch (tab) {
                  case ConfigurationUndefinedItem():
                    context.go(HomeRouterUndefinedTabPath.goPath());

                    break;
                  case NotesItem():
                    context.go(
                      HomeRouterNotesTabPath.namedLocation(
                        context,
                        configId: tab.configuration.id,
                      ),
                    );

                    break;
                  case SettingsItem():
                    context.go(HomeRouterSettingsTabPath.goPath());
                    break;
                  case LogoutItem():
                    break;
                }
              }
            },
            builder: (context, _) =>
                HomeScreen(bloc: context.bloc, child: child),
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: HomeRouterUndefinedTabPath.shortPath,
          pageBuilder: (context, state) {
            final theme = CustomPageTransistionsTheme.of(context);
            return CustomPage(
              key: HomeRouterUndefinedTabPath.getValueKey(state),
              theme: theme.fade,
              builder: (context) {
                return ConfigurationUndefinedScreen(onRoute: onRoute);
              },
            );
          },
          redirect: redirectToLoginPage,
        ),
        GoRoute(
          path: HomeRouterNotesTabPath.shortPath,
          name: HomeRouterNotesTabPath.name,
          pageBuilder: (context, state) {
            final theme = CustomPageTransistionsTheme.of(context);
            return CustomPage(
              key: HomeRouterNotesTabPath.getValueKey(state),
              theme: theme.fade,
              builder: (context) {
                final configId = HomeRouterNotesTabPath.getConfigId(state);

                if (configId.isNotEmpty) {
                  return notesRouterHelper.getInitialScreen(
                    configId: configId,
                  );
                } else {
                  return ConfigurationUndefinedScreen(onRoute: onRoute);
                }
              },
            );
          },
          redirect: redirectToLoginPage,
          routes: notesRouterHelper.routes,
        ),
        GoRoute(
            path: HomeRouterSettingsTabPath.shortPath,
            pageBuilder: (context, state) {
              final theme = CustomPageTransistionsTheme.of(context);
              return CustomPage(
                key: state.pageKey,
                theme: theme.fade,
                builder: (_) => settingsRouterHelper.initialScreen,
              );
            },
            redirect: redirectToLoginPage,
            routes: [...settingsRouterHelper.router]),
      ],
    ),
  ];

  Future onRoute(BuildContext context, Object action) async {
    if (action is ConfigurationUndefinedScreensRoute) {
      switch (action) {
        case ToSettingsRoute():
          context.bloc.add(
            const HomeFoldersBlocEvent.shouldChangeSelectedTab(
              tab: SettingsItem(),
            ),
          );
          Future.delayed(Durations.medium2).then((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(SettingsRouterConfigurationsPath.goPath());
            });
          });
          break;
      }
    }
  }
}

final class HomeRouterUndefinedTabPath {
  static const shortPath = '/home';
  static String goPath() => shortPath;

  static ValueKey getValueKey(GoRouterState state) => const ValueKey(shortPath);
}

final class HomeRouterNotesTabPath {
  static const name = 'NotesListScreen';
  static const shortPath = '/home/:${PathParameters.configId}';

  static String getConfigId(GoRouterState state) {
    final result = state.pathParameters[PathParameters.configId];
    assert(result != null && result.isNotEmpty);
    return result ?? '';
  }

  static String namedLocation(
    BuildContext context, {
    required String configId,
  }) =>
      context.namedLocation(
        name,
        pathParameters: {
          PathParameters.configId: configId,
        },
      );

  static ValueKey getValueKey(GoRouterState state) => ValueKey(
        state.pathParameters[PathParameters.configId],
      );
}

final class HomeRouterSettingsTabPath {
  static const shortPath = '/settings';
  static String goPath() => shortPath;
}

extension on BuildContext {
  HomeFoldersBloc get bloc => read<HomeFoldersBloc>();
}
