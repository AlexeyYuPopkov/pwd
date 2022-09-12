/*
 * Copyright (c) 2022-2022.
 * System Technologies <support@st.by>.
 * Alexey Popkov <popkov_oy@st.by> is author  this file.
 * The file more_page_information_parser.dart is part of UnifiedProject.
 * UnifiedProject can not be copied and/or distributed without the express permission of System Technologies.
 */

import 'package:flutter/material.dart';
import 'package:pwd/view/router/note_page_configuration.dart';
import 'package:pwd/view/router/main_router_delegate.dart';
import 'package:pwd/view/router/common/page_configuration.dart';

class PageInformationParser extends RouteInformationParser<PageConfiguration> {
  final MainRouterDelegate delegate;

  PageInformationParser({
    required this.delegate,
  });

  @override
  Future<PageConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    // Needed for web only.
    // todo: implement for interaction with input in browser url field
    return Future.value(
      NotePageConfiguration(),
    );
  }

  @override
  RouteInformation? restoreRouteInformation(
    PageConfiguration configuration,
  ) {
    // Needed for web only.
    // Provide path to browser url input field
    final location = delegate.pathComponents.join('/');
    debugPrint('RouteInformation location: $location');

    return RouteInformation(location: '/$location');
  }
}
