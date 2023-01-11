import 'dart:convert';

import 'package:pwd/notes/domain/database_path_provider.dart';
import 'package:pwd/settings/domain/data_storage_repository.dart';
import 'package:pwd/settings/domain/models/put_db_request.dart';

class SyncDataUsecases {
  static const _commitMessage = 'Update notes';
  static const _committerName = 'Alekseii';
  static const _committerEmail = 'alexey.yu.popkov@gmail.com';

  final DataStorageRepository dataStorageRepository;
  final DatabasePathProvider databasePathProvider;

  const SyncDataUsecases({
    required this.dataStorageRepository,
    required this.databasePathProvider,
  });

  Future<void> putDb() async {
    final bytes = await databasePathProvider.bytes;

    if (bytes != null && bytes.isNotEmpty) {
      final base64encoded = base64.encode(bytes);

      dataStorageRepository.putDb(
        request: PutDbRequest(
          message: _commitMessage,
          content: base64encoded,
          committer: const Committer(
            name: _committerName,
            email: _committerEmail,
          ),
        ),
      );
    }
  }
}
