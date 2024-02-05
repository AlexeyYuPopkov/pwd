// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
// import 'package:pwd/common/domain/remote_storage_configuration_provider.dart';

// const _tokenKey = 'RemoteStorageConfiguration.TokenKey';
// const _repoKey = 'RemoteStorageConfiguration.RepoKey';
// const _ownerKey = 'RemoteStorageConfiguration.OwnerKey';
// const _branchKey = 'RemoteStorageConfiguration.BranchKey';
// const _fileNameKey = 'RemoteStorageConfiguration.FileNameKey';

// class RemoteStorageConfigurationProviderImpl
//     implements RemoteStorageConfigurationProvider {
//   static const storage = FlutterSecureStorage();

//   RemoteStorageConfigurationProviderImpl();

//   RemoteStorageConfiguration _configuration =
//       const RemoteStorageConfiguration.empty();

//   @override
//   Future<RemoteStorageConfiguration> get configuration async {
//     if (_configuration is RemoteStorageConfigurationEmpty) {
//       _configuration = await _readConfiguration();
//       return _configuration;
//     } else {
//       return _configuration;
//     }
//   }

//   @override
//   Future<void> setConfiguration(
//     RemoteStorageConfiguration configuration,
//   ) async {
//     return dropConfiguration().then(
//       (_) => Future.wait([
//         storage.write(key: _tokenKey, value: configuration.token),
//         storage.write(key: _repoKey, value: configuration.repo),
//         storage.write(key: _ownerKey, value: configuration.owner),
//         storage.write(key: _branchKey, value: configuration.branch),
//         storage.write(key: _fileNameKey, value: configuration.fileName),
//       ]),
//     );
//   }

//   @override
//   Future<void> dropConfiguration() => Future.wait([
//         storage.delete(key: _tokenKey),
//         storage.delete(key: _repoKey),
//         storage.delete(key: _ownerKey),
//         storage.delete(key: _branchKey),
//         storage.delete(key: _fileNameKey),
//       ]).then(
//         (_) => _configuration = const RemoteStorageConfiguration.empty(),
//       );

//   Future<RemoteStorageConfiguration> _readConfiguration() async {
//     final results = await Future.wait([
//       storage.read(key: _tokenKey),
//       storage.read(key: _repoKey),
//       storage.read(key: _ownerKey),
//       storage.read(key: _branchKey),
//       storage.read(key: _fileNameKey),
//     ]);

//     final token = results[0];
//     final repo = results[1];
//     final owner = results[2];
//     final branch = results[3];
//     final fileName = results[4];

//     if (token != null &&
//         token.isNotEmpty &&
//         repo != null &&
//         repo.isNotEmpty &&
//         owner != null &&
//         owner.isNotEmpty &&
//         fileName != null &&
//         fileName.isNotEmpty) {
//       return RemoteStorageConfiguration.configuration(
//         token: token,
//         repo: repo,
//         owner: owner,
//         branch: branch,
//         fileName: fileName,
//       );
//     } else {
//       return const RemoteStorageConfiguration.empty();
//     }
//   }
// }
