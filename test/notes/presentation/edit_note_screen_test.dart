import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/workflowexecutions/v1.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/note_item_content.dart';
import 'package:pwd/notes/domain/usecases/delete_note_usecase.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/presentation/edit_note/bloc/edit_note_bloc.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_screen.dart';

import '../../../integration_test/pages/edit_note_screen/edit_note_screen_finders.dart';
import '../../test_tools/app_configuration_provider_tool.dart';

class MockNotesProviderUsecase extends Mock implements NotesProviderUsecase {}

class MockDeleteNoteUsecase extends Mock implements DeleteNoteUsecase {}

void main() {
  const configuration = GoogleDriveConfiguration(fileName: '');

  setUpAll(() {
    final di = DiStorage.shared;

    di.bind<NotesProviderUsecase>(
      module: null,
      () => MockNotesProviderUsecase(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<DeleteNoteUsecase>(
      module: null,
      () => MockDeleteNoteUsecase(),
      lifeTime: const LifeTime.single(),
    );

    AppConfigurationProviderTool.bindAppConfigurationProvider();
  });

  tearDownAll(() {
    DiStorage.shared.removeAll();
  });

  group('EditNoteScreen', () {
    Future dummyOnRoute(BuildContext context, Object route) async {}

    Future<void> setupAndShowScreen(
      WidgetTester tester, {
      required EditNoteScreenFinders finders,
      required BaseNoteItem noteItem,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlockingLoadingIndicator(
            child: EditNoteScreen(
              input: EditNoteScreenInput(
                configuration: configuration,
                noteItem: noteItem,
              ),
              onRoute: dummyOnRoute,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(finders.screen, findsOneWidget);
      expect(finders.blocConsumer, findsOneWidget);
      expect(finders.saveButton, findsOneWidget);
      expect(finders.deleteButton, findsOneWidget);

      expect(finders.titleTextField, findsOneWidget);
      expect(finders.subtitleTextField, findsOneWidget);
      expect(finders.contentTextField, findsOneWidget);

      expect(
        tester.widget<OutlinedButton>(finders.saveButton).enabled,
        false,
      );

      expect(
        tester.element(finders.blocConsumer).read<EditNoteBloc>().state,
        isA<CommonState>(),
      );
    }

    testWidgets('check initial state for new', (widgetTester) async {
      final finders = EditNoteScreenFinders();

      final newNoteItem = BaseNoteItem.newItem();

      await setupAndShowScreen(
        widgetTester,
        finders: finders,
        noteItem: newNoteItem,
      );

      expect(
        widgetTester.widget<EditNoteScreen>(finders.screen).input.noteItem,
        isA<UpdatedNoteItem>(),
      );

      expect(
        widgetTester.widget<OutlinedButton>(finders.deleteButton).enabled,
        false,
      );
    });

    testWidgets('check initial state for editing', (widgetTester) async {
      final finders = EditNoteScreenFinders();

      const noteItem = NoteItem(
        id: '',
        title: 'title',
        description: 'description',
        content: NoteStringContent(str: '1\n2\n3'),
        updated: 0,
        deletedTimestamp: null,
      );

      await setupAndShowScreen(
        widgetTester,
        finders: finders,
        noteItem: noteItem,
      );

      expect(
        widgetTester.widget<EditNoteScreen>(finders.screen).input.noteItem,
        isA<NoteItem>(),
      );

      expect(
        widgetTester.widget<OutlinedButton>(finders.deleteButton).enabled,
        true,
      );
    });

    testWidgets('delete', (widgetTester) async {
      final finders = EditNoteScreenFinders();

      const noteItem = NoteItem(
        id: '123',
        title: 'title',
        description: 'description',
        content: NoteStringContent(str: '1\n2\n3'),
        updated: 0,
        deletedTimestamp: null,
      );

      await setupAndShowScreen(
        widgetTester,
        finders: finders,
        noteItem: noteItem,
      );

      await widgetTester.tap(finders.deleteButton);

      await widgetTester.pumpAndSettle();

      final dialogOkButton = find.byKey(
        const Key(DialogHelperTestHelper.okCancelDialogOkButton),
      );

      await widgetTester.ensureVisible(dialogOkButton);

      final DeleteNoteUsecase usecase = DiStorage.shared.resolve();

      when(
        () => usecase.execute(id: '123', configuration: configuration),
      ).thenAnswer((_) => Future.value());

      await widgetTester.tap(dialogOkButton);

      await widgetTester.pumpAndSettle();

      expect(
        widgetTester.element(finders.blocConsumer).read<EditNoteBloc>().state,
        isA<DidDeleteState>(),
      );

      verify(
        () => usecase.execute(
          id: '123',
          configuration: configuration,
        ),
      );
    });

    testWidgets('delete with error', (widgetTester) async {
      final finders = EditNoteScreenFinders();

      const noteItem = NoteItem(
        id: '123',
        title: 'title',
        description: 'description',
        content: NoteStringContent(str: '1\n2\n3'),
        updated: 0,
        deletedTimestamp: null,
      );

      await setupAndShowScreen(
        widgetTester,
        finders: finders,
        noteItem: noteItem,
      );

      await widgetTester.tap(finders.deleteButton);

      await widgetTester.pumpAndSettle();

      final dialogOkButton = find.byKey(
        const Key(DialogHelperTestHelper.okCancelDialogOkButton),
      );

      await widgetTester.ensureVisible(dialogOkButton);

      final DeleteNoteUsecase usecase = DiStorage.shared.resolve();

      when(
        () => usecase.execute(id: '123', configuration: configuration),
      ).thenThrow(_Error());

      await widgetTester.tap(dialogOkButton);

      await widgetTester.pumpAndSettle();

      expect(
        widgetTester.element(finders.blocConsumer).read<EditNoteBloc>().state,
        isA<ErrorState>(),
      );

      verify(
        () => usecase.execute(
          id: '123',
          configuration: configuration,
        ),
      );

      final errorDialog = find.byKey(
        const Key(DialogHelperTestHelper.errorDialog),
      );

      await widgetTester.ensureVisible(errorDialog);
    });
  });
}

class _Error extends Exception {}
