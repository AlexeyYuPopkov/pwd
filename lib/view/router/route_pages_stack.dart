/*
 * Copyright (c) 2022-2022.
 * System Technologies <support@st.by>.
 * Alexey Popkov <popkov_oy@st.by> is author  this file.
 * The file route_pages_stack.dart is part of UnifiedProject.
 * UnifiedProject can not be copied and/or distributed without the express permission of System Technologies.
 */

import 'package:flutter/material.dart';

class RoutePagesStack {
  final List<Page> _pages;

  List<Page> get pages => List.unmodifiable(_pages);

  Page operator [](int i) => _pages[i];

  Page pop() => _pages.removeLast();
  void push(Page page) => _pages.add(page);

  List<String> get pathComponents =>
      _pages.map((e) => e.name).whereType<String>().toList();

  RoutePagesStack({
    List<Page> pages = const [],
  }) : _pages = pages;
}
