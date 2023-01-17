import 'dart:convert';

import 'package:pwd/common/domain/errors/network_error.dart';
import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
import 'package:pwd/notes/domain/remote_data_storage_repository.dart';
import 'package:pwd/notes/domain/usecases/notes_provider_usecase.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecases_errors.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';
import 'package:pwd/notes/domain/notes_repository.dart';

class SyncDataUsecase {
  static const _commitMessage = 'Update notes';
  static const _committerName = 'Alekseii';
  static const _committerEmail = 'alexey.yu.popkov@gmail.com';

  final RemoteStorageConfigurationProvider remoteStorageConfigurationProvider;
  final RemoteDataStorageRepository remoteStorageRepository;
  final NotesRepository notesRepository;
  final NotesProviderUsecase notesProvider;

  SyncDataUsecase({
    required this.remoteStorageConfigurationProvider,
    required this.remoteStorageRepository,
    required this.notesRepository,
    required this.notesProvider,
  });

  Future<void> sync() async {
    try {
      final configuration =
          await remoteStorageConfigurationProvider.configuration;
      final result = await remoteStorageRepository.getDb(
        configuration: configuration,
      );

      final base64Str = result.content.replaceAll(RegExp(r'\s+'), '');

      var jsonStr = utf8.decode(
        base64Decode(base64Str),
        allowMalformed: true,
      );

      if (jsonStr.trim().isEmpty) {
        final date = DateTime.now().toIso8601String();
        jsonStr = '{"notes":[],"date": "$date"}';
      }

      final jsonMap = jsonDecode(jsonStr);

      await notesRepository.importNotes(
        jsonMap: jsonMap,
      );

      await notesProvider.readNotes();

      await _putDb();
    } on NotFoundError catch (e) {
      throw SyncDataError.destinationNotFound(parentError: e);
    } catch (e) {
      throw SyncDataError.unknown(parentError: e);
    }
  }

  Future<PutDbResponse?> _putDb() async {
    try {
      final notesStr = await notesRepository.exportNotes(
        exportDate: DateTime.now(),
      );

      if (notesStr.isNotEmpty) {
        final bytes = utf8.encode(notesStr);
        final base64encoded = base64.encode(bytes);
        final sha = await _getSha();

        final configuration =
            await remoteStorageConfigurationProvider.configuration;

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
      } else {
        return null;
      }
    } on NotFoundError catch (e) {
      throw SyncDataError.destinationNotFound(parentError: e);
    } catch (e) {
      throw SyncDataError.unknown(parentError: e);
    }
  }

  Future<String?> _getSha() async {
    try {
      final configuration =
          await remoteStorageConfigurationProvider.configuration;

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
