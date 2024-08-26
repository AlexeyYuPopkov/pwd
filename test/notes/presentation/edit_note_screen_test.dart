import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/workflowexecutions/v1.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/note_item_content.dart';
import 'package:pwd/notes/domain/usecases/delete_note_usecase.dart';
import 'package:pwd/notes/domain/usecases/read_note_usecase.dart';
import 'package:pwd/notes/domain/usecases/read_notes_usecase.dart';
import 'package:pwd/notes/domain/usecases/update_note_usecase.dart';
import 'package:pwd/notes/presentation/edit_note/bloc/edit_note_bloc.dart';
import 'package:pwd/notes/presentation/edit_note/bloc/edit_note_page_data.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_screen.dart';

import 'edit_note_screen_finders.dart';
import '../../test_tools/app_configuration_provider_tool.dart';
import '../../test_tools/test_tools.dart';

class MockReadNoteUsecase extends Mock implements ReadNoteUsecase {}

class MockReadNotesUsecase extends Mock implements ReadNotesUsecase {}

class MockUpdateNoteUsecase implements UpdateNoteUsecase {
  List<String> callsParameters = [];

  @override
  Future<void> execute(BaseNoteItem noteItem,
      {required String configurationId}) {
    callsParameters.add('${noteItem.id}, $configurationId');

    return Future.delayed(Durations.medium1);
  }
}

class MockDeleteNoteUsecase implements DeleteNoteUsecase {
  List<String> callsParameters = [];
  Object? error;

  @override
  Future<void> execute({
    required String id,
    required String configurationId,
  }) async {
    callsParameters.add('$id, $configurationId');

    if (error != null) {
      throw error!;
    }

    return Future.delayed(Durations.medium1);
  }
}

void main() {
  final finders = EditNoteScreenFinders();

  setUp(() {
    final di = DiStorage.shared;

    di.bind<ReadNoteUsecase>(
      module: null,
      () => MockReadNoteUsecase(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<ReadNotesUsecase>(
      module: null,
      () => MockReadNotesUsecase(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<UpdateNoteUsecase>(
      module: null,
      () => MockUpdateNoteUsecase(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<DeleteNoteUsecase>(
      module: null,
      () => MockDeleteNoteUsecase(),
      lifeTime: const LifeTime.single(),
    );

    AppConfigurationProviderTool.bindAppConfigurationProvider();
  });

  tearDown(() {
    DiStorage.shared.removeAll();
  });

  Future dummyOnRoute(BuildContext context, Object route) async {}

  Future<void> setupAndShowScreen(
    WidgetTester tester, {
    required EditNoteScreenInput input,
  }) async {
    await tester.pumpWidget(
      CreateApp.createMaterialApp(
        child: EditNoteScreen(
          input: input,
          onRoute: dummyOnRoute,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(finders.screen, findsOneWidget);
    expect(finders.blocConsumer, findsOneWidget);
    expect(finders.saveButton, findsOneWidget);
    expect(finders.deleteButton, findsOneWidget);
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

  group('EditNoteScreen', () {
    testWidgets(
      'check initial state for updating',
      (widgetTester) async {
        const expectResult = NoteItem(
          id: '',
          content: NoteContent(
            items: [
              NoteContentItem(text: '123'),
            ],
          ),
          updated: 0,
        );

        final ReadNoteUsecase readNoteUsecase = DiStorage.shared.resolve();

        when(
          () => readNoteUsecase.execute(configId: 'configId', noteId: 'noteId'),
        ).thenAnswer((_) async {
          return expectResult;
        });

        await setupAndShowScreen(
          widgetTester,
          input: const EditNoteScreenInput.update(
            configId: 'configId',
            noteId: 'noteId',
          ),
        );

        expect(
          widgetTester.widget<OutlinedButton>(finders.deleteButton).enabled,
          true,
        );

        await widgetTester.pumpAndSettle();

        expect(
          widgetTester
              .element(finders.blocConsumer)
              .read<EditNoteBloc>()
              .state
              .data
              .note
              .data,
          expectResult,
        );
      },
    );

    testWidgets(
      'updating',
      (widgetTester) async {
        const initialNote = NoteItem(
          id: 'noteId',
          content: NoteContent(
            items: [
              NoteContentItem(text: '123'),
            ],
          ),
          updated: 0,
        );

        final ReadNoteUsecase readNoteUsecase = DiStorage.shared.resolve();

        when(
          () => readNoteUsecase.execute(configId: 'configId', noteId: 'noteId'),
        ).thenAnswer((_) async {
          return initialNote;
        });

        await setupAndShowScreen(
          widgetTester,
          input: const EditNoteScreenInput.update(
            configId: 'configId',
            noteId: 'noteId',
          ),
        );

        expect(
          widgetTester.widget<OutlinedButton>(finders.deleteButton).enabled,
          true,
        );

        await widgetTester.pumpAndSettle();

        expect(
          widgetTester
              .element(finders.blocConsumer)
              .read<EditNoteBloc>()
              .state
              .data
              .note
              .data,
          initialNote,
        );

        final textField =
            widgetTester.widget<TextFormField>(finders.contentTextField);

        await widgetTester.tap(finders.contentTextField);

        await widgetTester.enterText(finders.contentTextField, '123456');

        expect(
          widgetTester.widget<OutlinedButton>(finders.saveButton).enabled,
          false,
        );

        expect(textField.controller?.text, '123456');

        await widgetTester.pumpAndSettle();

        expect(
          widgetTester.widget<OutlinedButton>(finders.saveButton).enabled,
          true,
        );

        await widgetTester.tap(finders.saveButton);

        final updateUsecase = DiStorage.shared.resolve<UpdateNoteUsecase>()
            as MockUpdateNoteUsecase;

        await widgetTester.pumpAndSettle();

        expect(
          widgetTester.element(finders.blocConsumer).read<EditNoteBloc>().state,
          isA<DidSaveState>(),
        );

        final actualNote = widgetTester
            .element(finders.blocConsumer)
            .read<EditNoteBloc>()
            .state
            .data
            .note
            .data;

        expect(actualNote?.content.items.length, 1);
        expect(actualNote?.content.items[0].text, '123456');
        expect(updateUsecase.callsParameters.length, 1);
        expect(updateUsecase.callsParameters[0], 'noteId, configId');
      },
    );

    testWidgets('check initial state for creating', (widgetTester) async {
      await setupAndShowScreen(widgetTester,
          input: const EditNoteScreenInput.create(configId: 'configId'));

      expect(
        widgetTester.widget<OutlinedButton>(finders.deleteButton).enabled,
        false,
      );

      expect(
        widgetTester.widget<OutlinedButton>(finders.saveButton).enabled,
        false,
      );

      await widgetTester.pumpAndSettle();

      expect(
        widgetTester
            .element(finders.blocConsumer)
            .read<EditNoteBloc>()
            .state
            .data
            .note
            .data,
        isA<NewNoteItem>(),
      );
    });
  });

  group('EditNoteScreen - delete', () {
    testWidgets('delete', (widgetTester) async {
      final noteItem = NoteItem(
        id: '123',
        content: NoteContent.fromText('1\n2\n3'),
        updated: 0,
      );

      final ReadNoteUsecase readNoteUsecase = DiStorage.shared.resolve();

      when(
        () => readNoteUsecase.execute(configId: 'configId', noteId: 'noteId'),
      ).thenAnswer((_) async {
        return noteItem;
      });

      await setupAndShowScreen(
        widgetTester,
        input: const EditNoteScreenInput.update(
          configId: 'configId',
          noteId: 'noteId',
        ),
      );

      await widgetTester.pumpAndSettle();

      await widgetTester.tap(finders.deleteButton);

      await widgetTester.pumpAndSettle();

      final dialogOkButton = find.byKey(
        const Key(DialogHelperTestHelper.okCancelDialogOkButton),
      );

      await widgetTester.ensureVisible(dialogOkButton);

      await widgetTester.tap(dialogOkButton);

      await widgetTester.pumpAndSettle();

      expect(
        widgetTester.element(finders.blocConsumer).read<EditNoteBloc>().state,
        isA<DidDeleteState>(),
      );
      final usecase = DiStorage.shared.resolve<DeleteNoteUsecase>()
          as MockDeleteNoteUsecase;
      expect(usecase.callsParameters.length, 1);
      expect(usecase.callsParameters[0], 'noteId, configId');
    });

    testWidgets('delete with error', (widgetTester) async {
      final noteItem = NoteItem(
        id: '123',
        content: NoteContent.fromText('1\n2\n3'),
        updated: 0,
      );

      final ReadNoteUsecase readNoteUsecase = DiStorage.shared.resolve();

      when(
        () => readNoteUsecase.execute(configId: 'configId', noteId: 'noteId'),
      ).thenAnswer((_) async {
        return noteItem;
      });

      await setupAndShowScreen(
        widgetTester,
        input: const EditNoteScreenInput.update(
          configId: 'configId',
          noteId: 'noteId',
        ),
      );

      await widgetTester.tap(finders.deleteButton);

      await widgetTester.pumpAndSettle();

      final dialogOkButton = find.byKey(
        const Key(DialogHelperTestHelper.okCancelDialogOkButton),
      );

      await widgetTester.ensureVisible(dialogOkButton);

      final usecase = DiStorage.shared.resolve<DeleteNoteUsecase>()
          as MockDeleteNoteUsecase;

      usecase.error = _Error();

      await widgetTester.tap(dialogOkButton);

      await widgetTester.pumpAndSettle();

      expect(
        widgetTester.element(finders.blocConsumer).read<EditNoteBloc>().state,
        isA<ErrorState>(),
      );

      expect(usecase.callsParameters.length, 1);
      expect(usecase.callsParameters[0], 'noteId, configId');

      final errorDialog = find.byKey(
        const Key(DialogHelperTestHelper.errorDialog),
      );

      await widgetTester.ensureVisible(errorDialog);
    });
  });
}

class _Error extends Exception {}
