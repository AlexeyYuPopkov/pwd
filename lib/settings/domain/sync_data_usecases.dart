import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:pwd/notes/domain/database_path_provider.dart';
import 'package:pwd/notes/domain/notes_provider_impl.dart';
import 'package:pwd/notes/domain/notes_repository.dart';
import 'package:pwd/settings/domain/data_storage_repository.dart';
import 'package:pwd/settings/domain/models/export_db_data.dart';
import 'package:pwd/settings/domain/models/put_db_request.dart';
import 'package:pwd/settings/domain/models/put_db_response.dart';

class SyncDataUsecases {
  static const _commitMessage = 'Update notes';
  static const _committerName = 'Alekseii';
  static const _committerEmail = 'alexey.yu.popkov@gmail.com';

  final DataStorageRepository dataStorageRepository;
  final DatabasePathProvider databasePathProvider;
  final NotesRepository notesRepository;
  final NotesProvider notesProvider;

  const SyncDataUsecases({
    required this.dataStorageRepository,
    required this.databasePathProvider,
    required this.notesRepository,
    required this.notesProvider,
  });

  Future<PutDbResponse?> putDb() async {
    final notes = await notesRepository.exportNotes();
    final jsonMap = ExportDbData(
      notes: notes,
      date: DateTime.now(),
    ).toJson();

    final jsonStr = jsonEncode(jsonMap);

    // final bytes = await databasePathProvider.bytes;

    // if (bytes != null && bytes.isNotEmpty) {
    if (jsonStr.isNotEmpty) {
      final base64encoded = utf8.fuse(base64).encode(jsonStr);

      return dataStorageRepository.putDb(
        request: PutDbRequest(
          message: _commitMessage,
          content: base64encoded,
          committer: const Committer(
            name: _committerName,
            email: _committerEmail,
          ),
        ),
      );
    } else {
      return null;
    }
  }

  Future<void> getDb() async {
    final result = await dataStorageRepository.getDb();

    final base64Str = result.content.replaceAll(RegExp(r'\s+'), '');

    final jsonStr = utf8.decode(base64Decode(base64Str), allowMalformed: true);

    final jsonMap = jsonDecode(jsonStr);

    final dbImportData = ExportDbData.fromJson(jsonMap);

    await notesRepository.importNotes(dbImportData.notes);
  }
}
