import 'dart:convert';

import 'package:pwd/common/domain/errors/network_error.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
import 'package:pwd/notes/domain/remote_data_storage_repository.dart';
import 'package:pwd/notes/domain/usecases/git_notes_provider_usecase.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecases_errors.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';
import 'package:pwd/notes/domain/notes_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_usecase.dart';

final class SyncGitItemUsecase implements SyncUsecase {
  static const _commitMessage = 'Update notes';
  static const _committerName = 'Alekseii';
  static const _committerEmail = 'alexey.yu.popkov@gmail.com';

  final RemoteDataStorageRepository remoteStorageRepository;
  final NotesRepository notesRepository;
  final NotesProviderUsecase notesProvider;

  String? lastSha;

  SyncGitItemUsecase({
    required this.remoteStorageRepository,
    required this.notesRepository,
    required this.notesProvider,
  });

  @override
  Future<void> sync({required RemoteStorageConfiguration configuration}) async {
    // TODO: refactor
    switch (configuration) {
      case GitConfiguration():
        break;
      case GoogleDriveConfiguration():
        assert(false);
        return;
    }

    try {
      final result = await remoteStorageRepository.getDb(
        configuration: configuration,
      );

      lastSha = result.sha;

      final base64Str = result.content.replaceAll(RegExp(r'\s+'), '');

      var jsonStr = utf8.decode(
        base64Decode(base64Str),
        allowMalformed: true,
      );

      if (jsonStr.trim().isEmpty) {
        jsonStr = notesRepository.createEmptyDbContent(
          DateTime.now().timestamp,
        );
      }

      final jsonMap = jsonDecode(jsonStr);

      await notesRepository.importNotes(
        jsonMap: jsonMap,
      );

      await notesProvider.readNotes();

      final localTimestamp = await notesRepository.lastRecordTimestamp();
      final remoteTimestamp = jsonMap['timestamp'];

      if (remoteTimestamp is! int) {
        await updateRemote(configuration: configuration);
      } else {
        if (localTimestamp != remoteTimestamp) {
          await updateRemote(configuration: configuration);
        }
      }
    } on NotFoundError catch (e) {
      throw SyncDataError.destinationNotFound(parentError: e);
    } catch (e) {
      throw SyncDataError.unknown(parentError: e);
    }
  }

  @override
  Future<void> updateRemote({
    required RemoteStorageConfiguration configuration,
  }) async {
    // TODO: refactor
    switch (configuration) {
      case GitConfiguration():
        break;
      case GoogleDriveConfiguration():
        assert(false);
        return;
    }

    try {
      final notesStr = await notesRepository.exportNotes();

      if (notesStr.isNotEmpty) {
        final sha = lastSha ?? await _getSha(configuration: configuration);
        overrideDbWithContent(
          contentStr: notesStr,
          sha: sha,
          configuration: configuration,
        );
      }
    } on NotFoundError catch (e) {
      throw SyncDataError.destinationNotFound(parentError: e);
    } catch (e) {
      throw SyncDataError.unknown(parentError: e);
    }
  }

  Future<PutDbResponse?> createOrOverrideDb({
    required GitConfiguration configuration,
  }) async {
    try {
      final ssa = lastSha ?? await _getSha(configuration: configuration);

      return overrideDbWithContent(
        contentStr: notesRepository.createEmptyDbContent(
          DateTime.now().timestamp,
        ),
        sha: ssa,
        configuration: configuration,
      );
    } catch (e) {
      return overrideDbWithContent(
        contentStr: notesRepository.createEmptyDbContent(
          DateTime.now().timestamp,
        ),
        sha: null,
        configuration: configuration,
      );
    }
  }

  Future<PutDbResponse?> overrideDbWithContent({
    required String contentStr,
    required String? sha,
    required GitConfiguration configuration,
  }) async {
    final bytes = utf8.encode(contentStr);
    final base64encoded = base64.encode(bytes);

    return remoteStorageRepository.putDb(
      configuration: configuration,
      request: PutDbRequest(
        message: _commitMessage,
        content: base64encoded,
        sha: sha,
        committer: const Committer(
          name: _committerName,
          email: _committerEmail,
        ),
        branch: null,
      ),
    );
  }

  Future<String?> _getSha({required GitConfiguration configuration}) async {
    try {
      return await remoteStorageRepository
          .getDb(configuration: configuration)
          .then((result) => result.sha);
    } on NotFoundError catch (e) {
      throw SyncDataError.destinationNotFound(parentError: e);
    } catch (e) {
      throw SyncDataError.unknown(parentError: e);
    }
  }
}

extension on DateTime {
  int get timestamp => millisecondsSinceEpoch * 1000;
}
