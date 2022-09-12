/*
 * Copyright (c) 2022-2022.
 * System Technologies <support@st.by>.
 * Alexey Popkov <popkov_oy@st.by> is author  this file.
 * The file more_page_actions.dart is part of UnifiedProject.
 * UnifiedProject can not be copied and/or distributed without the express permission of System Technologies.
 */

abstract class MainPageAction {
  const MainPageAction();
  const factory MainPageAction.onEdit() = OnNoteEdit;
}

class OnNoteEdit extends MainPageAction {
  const OnNoteEdit();
}
