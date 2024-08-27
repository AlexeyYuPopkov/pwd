import 'dart:async';

import 'package:di_storage/di_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/dialogs/dialog_helper.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/notes/domain/model/note_item_content.dart';
import 'package:pwd/notes/domain/usecases/read_note_usecase.dart';
import 'package:pwd/notes/presentation/note_details/bloc/note_details_screen_state.dart';
import 'package:pwd/notes/presentation/note_details/note_details_screen.dart';

import '../../../test_tools/app_configuration_provider_tool.dart';
import '../../../test_tools/test_tools.dart';
import 'note_details_screen_finders.dart';

final class MockReadNoteUsecase implements ReadNoteUsecase {
  static const expectResult = NoteItem(
    id: 'noteId',
    content: NoteContent(
      items: [
        NoteContentItem(text: '123'),
      ],
    ),
    updated: 0,
  );

  final shouldExit = Completer<bool>();

  Object? error;

  @override
  Future<NoteItem> execute({
    required String configId,
    required String noteId,
  }) async {
    if (error != null) {
      throw error!;
    }
    shouldExit.complete(true);
    return expectResult;
  }
}

void main() {
  final finders = NoteDetailsScreenFinders();
  late MockReadNoteUsecase usecase;

  setUp(() {
    final di = DiStorage.shared;

    usecase = MockReadNoteUsecase();
    di.bind<ReadNoteUsecase>(
      module: null,
      () => usecase,
      lifeTime: const LifeTime.single(),
    );

    AppConfigurationProviderTool.bindAppConfigurationProvider();
  });

  tearDown(() {
    DiStorage.shared.removeAll();
  });

  Future<void> setupAndShowScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      CreateApp.createMaterialApp(
        child: const NoteDetailsScreen(
          configId: 'configId',
          noteId: 'noteId',
        ),
      ),
    );
  }

  group('NoteDetailsScreen', () {
    testWidgets(
      'note is visible',
      (tester) async {
        await setupAndShowScreen(tester);
        await tester.pumpAndSettle();

        final shouldExit = await tester.runAsync(() {
          return usecase.shouldExit.future;
        });

        expect(shouldExit, true);
        expect(finders.notes, findsAtLeastNWidgets(2));
        await tester.ensureVisible(finders.notes.first);
        await tester.ensureVisible(finders.notes.last);
      },
    );

    testWidgets(
      'showd error',
      (tester) async {
        usecase.error = _Error();

        await setupAndShowScreen(tester);
        await tester.pumpAndSettle();

        expect(
          finders.bloc(tester).state,
          isA<ErrorState>(),
        );

        final errorDialog = find.byKey(
          const Key(DialogHelperTestHelper.errorDialog),
        );

        await tester.ensureVisible(errorDialog);
      },
    );
  });
}

class _Error {}
