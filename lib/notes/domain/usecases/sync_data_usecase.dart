import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/notes/domain/data_storage_repository.dart';
import 'package:pwd/notes/domain/sync_data_usecases_errors.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/export_db_data.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/notes_repository.dart';


class SyncDataUsecase {
  static const _commitMessage = 'Update notes';
  static const _committerName = 'Alekseii';
  static const _committerEmail = 'alexey.yu.popkov@gmail.com';

  final DataStorageRepository dataStorageRepository;

  final NotesRepository notesRepository;
  final NotesProviderUsecase notesProvider;

  SyncDataUsecase({
    required this.dataStorageRepository,
    required this.notesRepository,
    required this.notesProvider,
  });

  Future<void> getDb() async {
    try {
      final result = await dataStorageRepository.getDb();

      final base64Str = result.content.replaceAll(RegExp(r'\s+'), '');

      final jsonStr = utf8.decode(
        base64Decode(base64Str),
        allowMalformed: true,
      );

      final jsonMap = jsonDecode(jsonStr);

      final dbImportData = ExportDbData.fromJson(jsonMap);

      final changesCount = await notesRepository.importNotes(
        notes: dbImportData.notes,
      );

      await notesProvider.readNotes();

      if (changesCount > 0) {
        await _putDb();
      } else {
        debugPrint('no need to update remote DB');
      }
    } catch (e) {
      throw SyncDataError(parentError: e);
    }
  }

  Future<PutDbResponse?> _putDb() async {
    try {
      final notes = await notesRepository.exportNotes();
      final jsonMap = ExportDbData(
        notes: notes,
        date: DateTime.now(),
      ).toJson();

      final jsonStr = jsonEncode(jsonMap);

      if (jsonStr.isNotEmpty) {
        final bytes = utf8.encode(jsonStr);
        final base64encoded = base64.encode(bytes);
        final sha = await _getSha();

        return dataStorageRepository.putDb(
          request: PutDbRequest(
            message: _commitMessage,
            content: base64encoded,
            sha: sha,
            committer: const Committer(
              name: _committerName,
              email: _committerEmail,
            ),
          ),
        );
      } else {
        return null;
      }
    } catch (e) {
      throw SyncDataError(parentError: e);
    }
  }

  Future<String> _getSha() async => dataStorageRepository
      .getDb()
      .then((result) => result.sha)
      .catchError((e) => throw SyncDataError(parentError: e));
}
