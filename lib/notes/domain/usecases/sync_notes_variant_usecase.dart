// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:pwd/common/domain/errors/app_error.dart';
// import 'package:pwd/common/domain/errors/network_error.dart';
// import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
// import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';
// import 'package:pwd/common/domain/usecases/hash_usecase.dart';
// import 'package:pwd/common/domain/usecases/pin_usecase.dart';
// import 'package:pwd/notes/domain/local_repository.dart';
// import 'package:pwd/notes/domain/remote_data_storage_repository.dart';
// import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';
// import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
// import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';
// import 'package:pwd/notes/domain/usecases/sync_data_usecase.dart';

// abstract interface class SyncDataVariantUsecase implements SyncDataUsecase {}

// // TODO: remove this file
// final class SyncNotesVariantUsecaseImpl implements SyncDataVariantUsecase {
//   final LocalRepository repository;
//   final PinUsecase pinUsecase;
//   final HashUsecase hashUsecase;

//   final RemoteStorageConfigurationProvider remoteStorageConfigurationProvider;
//   final RemoteDataStorageRepository remoteStorageRepository;

//   String? lastSha;

//   SyncNotesVariantUsecaseImpl({
//     required this.repository,
//     required this.pinUsecase,
//     required this.hashUsecase,
//     required this.remoteStorageConfigurationProvider,
//     required this.remoteStorageRepository,
//   });

//   @override
//   Future<void> sync() async {
//     final pin = pinUsecase.getPinOrThrow();

//     final configuration =
//         await remoteStorageConfigurationProvider.configuration;

//     final result = await _getDbOrCreateIfEpsent(configuration);

//     lastSha = result.sha;

//     final base64Str = result.content.replaceAll(RegExp(r'\s+'), '');

//     final bytes = base64.decode(base64Str);

//     return repository.migrateWithDatabasePath(bytes: bytes, key: pin.pinSha512);
//   }

//   Future<GetDbResponse> _getDbOrCreateIfEpsent(
//     RemoteStorageConfiguration configuration,
//   ) async {
//     try {
//       final result = await remoteStorageRepository.getRealmDb(
//         configuration: configuration,
//       );

//       return result;
//     } catch (e) {
//       if (e is NotFoundError) {
//         await updateRemote();

//         return _getDbOrCreateIfEpsent(configuration);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   @override
//   Future<void> updateRemote() async {
//     final pin = pinUsecase.getPinOrThrow();
//     // final timestamp = await repository.getTimestamp(key: pin.pinSha512);
//     final path = await repository.getPath(key: pin.pinSha512);
//     final file = File(path);

//     // file.lastModified()
//     final data = await file.readAsBytes();

//     await _overrideDbWithContent(bytes: data, sha: lastSha);
//   }
// }

// extension on SyncNotesVariantUsecaseImpl {
//   Future<PutDbResponse?> _overrideDbWithContent({
//     required String? sha,
//     required Uint8List bytes,
//   }) async {
//     const commitMessage = 'Update notes';
//     const committerName = 'Alekseii';
//     const committerEmail = 'alexey.yu.popkov@gmail.com';

//     final base64encoded = base64.encode(bytes);

//     final configuration =
//         await remoteStorageConfigurationProvider.configuration;

//     return remoteStorageRepository.putRealmDb(
//       configuration: configuration,
//       request: PutDbRequest(
//         message: commitMessage,
//         content: base64encoded,
//         sha: sha,
//         committer: const Committer(
//           name: committerName,
//           email: committerEmail,
//         ),
//         branch: null,
//       ),
//     );
//   }
// }

// final class SyncNotesVariantUsecaseEmptyPinError extends AppError {
//   const SyncNotesVariantUsecaseEmptyPinError() : super(message: '');
// }
