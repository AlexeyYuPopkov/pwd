/*
 * Copyright (c) 2022-2022.
 * System Technologies <support@st.by>.
 * Alexey Popkov <popkov_oy@st.by> is author  this file.
 * The file more_router_state.dart is part of UnifiedProject.
 * UnifiedProject can not be copied and/or distributed without the express permission of System Technologies.
 */

import 'package:flutter/material.dart';
import 'package:pwd/view/router/common/page_configuration.dart';
import 'package:pwd/view/router/note_page_configuration.dart';

class MainRouterState extends ChangeNotifier {
  PageConfiguration initialPage;
  PageConfiguration? _selectedPage;

  MainRouterState() : initialPage = NotePageConfiguration();

  PageConfiguration? get selectedPage => _selectedPage;

  set selectedPage(PageConfiguration? selectedPage) {
    _selectedPage = selectedPage;

    notifyListeners();
  }
}
