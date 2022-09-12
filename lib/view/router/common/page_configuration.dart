/*
 * Copyright (c) 2022-2022.
 * System Technologies <support@st.by>.
 * Alexey Popkov <popkov_oy@st.by> is author  this file.
 * The file page_configuration.dart is part of UnifiedProject.
 * UnifiedProject can not be copied and/or distributed without the express permission of System Technologies.
 */

abstract class PageConfiguration {
  String get name;
}

abstract class RootPageConfiguration extends PageConfiguration {
  String get initialPath;
  List<PageConfiguration> get initialPages;
}



