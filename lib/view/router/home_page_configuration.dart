import 'package:pwd/view/router/common/page_configuration.dart';

class NotePageConfiguration extends RootPageConfiguration {
  @override
  final String name = '';

  NotePageConfiguration();

  @override
  List<PageConfiguration> get initialPages => [];

  @override
  String get initialPath => '';
}

class EditNotePageConfiguration extends PageConfiguration {
  @override
  final String name = 'edit';
}
