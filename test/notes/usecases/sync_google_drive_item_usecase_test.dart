import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/workflowexecutions/v1.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/deleted_items_provider.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/model/google_drive_file.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_google_drive_item_usecase.dart';

class MockGoogleRepository extends Mock implements GoogleRepository {}

class MockRealmLocalRepository extends Mock implements RealmLocalRepository {}

class MockPinUsecase extends Mock implements PinUsecase {}

class MockChecksumChecker extends Mock implements ChecksumChecker {}

class MockDeletedItemsProvider extends Mock implements DeletedItemsProvider {}

void main() {
  late MockGoogleRepository googleRepository;
  late MockRealmLocalRepository repository;
  late MockPinUsecase pinUsecase;
  late MockChecksumChecker checksumChecker;
  late MockDeletedItemsProvider deletedItemsProvider;
  late SyncGoogleDriveItemUsecase usecase;

  setUp(() {
    googleRepository = MockGoogleRepository();
    repository = MockRealmLocalRepository();
    pinUsecase = MockPinUsecase();
    checksumChecker = MockChecksumChecker();
    deletedItemsProvider = MockDeletedItemsProvider();

    usecase = SyncGoogleDriveItemUsecase(
      googleRepository: googleRepository,
      realmRepository: repository,
      pinUsecase: pinUsecase,
      checksumChecker: checksumChecker,
      deletedItemsProvider: deletedItemsProvider,
    );
  });

  const configuration = GoogleDriveConfiguration(fileName: 'fileName');

  const pin = Pin(
    pin: '',
    pinSha512: [],
  );

  final target = configuration.getTarget(
    pin: pin,
  );

  final realmDatabaseAsBytes = Uint8List.fromList([]);

  final googleDriveFile = GoogleDriveFile(
    id: '',
    checksum: 'not empty',
    name: configuration.fileName,
  );

  group(
    'SyncGoogleDriveItemUsecase: updateRemote',
    () {
      test(
        'SyncGoogleDriveItemUsecase: updateRemote check all methods called',
        () async {
          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);
          when(
            () => repository.readAsBytes(
              target: target,
            ),
          ).thenAnswer(
            (_) async => realmDatabaseAsBytes,
          );
          when(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              target: configuration,
            ),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          await usecase.updateRemote(configuration: configuration);

          final verification = verifyInOrder(
            [
              () => pinUsecase.getPinOrThrow(),
              () => repository.readAsBytes(
                    target: target,
                  ),
              () => googleRepository.updateRemote(
                    realmDatabaseAsBytes,
                    target: configuration,
                  ),
            ],
          );

          expect(verification.length, 3);
        },
      );

      test(
        'SyncGoogleDriveItemUsecase: updateRemote check all methods called and throws',
        () async {
          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);
          when(() => repository.readAsBytes(
                target: configuration.getTarget(pin: pin),
              )).thenAnswer(
            (_) async => realmDatabaseAsBytes,
          );
          when(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              target: configuration,
            ),
          ).thenAnswer(
            (_) => Future.error(_Exception()),
          );

          final result = usecase.updateRemote(configuration: configuration);

          expect(result, throwsA(isA<_Exception>()));
        },
      );
    },
  );

  group(
    'SyncGoogleDriveItemUsecase: sync, new file should create',
    () {
      test(
        'check all methods called',
        () async {
          when(
            () => googleRepository.getFile(target: configuration),
          ).thenAnswer(
            (_) => Future.value(null),
          );

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);
          when(() => repository.readAsBytes(
                target: configuration.getTarget(pin: pin),
              )).thenAnswer(
            (_) async => realmDatabaseAsBytes,
          );
          when(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              target: configuration,
            ),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => checksumChecker.setChecksum(
              googleDriveFile.checksum,
            ),
          ).thenAnswer((invocation) async {});

          await usecase.sync(configuration: configuration);

          final verification = verifyInOrder(
            [
              () => pinUsecase.getPinOrThrow(),
              () => repository.readAsBytes(
                    target: configuration.getTarget(pin: pin),
                  ),
              () => googleRepository.updateRemote(
                    realmDatabaseAsBytes,
                    target: configuration,
                  ),
              () => checksumChecker.setChecksum(googleDriveFile.checksum),
            ],
          );

          expect(verification.length, 4);
        },
      );

      test(
        'check all methods called, new file should create',
        () async {
          when(
            () => googleRepository.getFile(target: configuration),
          ).thenAnswer(
            (_) => Future.value(null),
          );

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);
          when(() => repository.readAsBytes(
                target: configuration.getTarget(pin: pin),
              )).thenAnswer(
            (_) async => realmDatabaseAsBytes,
          );
          when(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              target: configuration,
            ),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => checksumChecker.setChecksum(
              googleDriveFile.checksum,
            ),
          ).thenThrow(_Exception());

          final result = usecase.sync(configuration: configuration);

          expect(result, throwsA(isA<_Exception>()));
        },
      );
    },
  );

  group(
    'SyncGoogleDriveItemUsecase: sync, new file should not create',
    () {
      test(
        'sync not needed, check all methods called',
        () async {
          when(
            () => googleRepository.getFile(target: configuration),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => checksumChecker.getChecksum(),
          ).thenAnswer(
            (_) async => 'not empty',
          );

          await usecase.sync(configuration: configuration);

          final verification = verifyInOrder(
            [
              () => googleRepository.getFile(target: configuration),
              () => checksumChecker.getChecksum(),
            ],
          );

          expect(verification.length, 2);

          verifyNever(() => googleRepository.downloadFile(googleDriveFile));
          verifyNever(() => pinUsecase.getPinOrThrow());
          verifyNever(() => deletedItemsProvider.getDeletedItems());
          verifyNever(
            () => repository.migrateWithDatabasePath(
              bytes: realmDatabaseAsBytes,
              target: configuration.getTarget(pin: pin),
              deleted: const {},
            ),
          );
          verifyNever(() => repository.readAsBytes(
                target: configuration.getTarget(pin: pin),
              ));

          verifyNever(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              target: configuration,
            ),
          );

          verifyNever(() => googleRepository.getFile(target: configuration));

          verifyNever(
            () => checksumChecker.setChecksum(
              googleDriveFile.checksum,
            ),
          );
        },
      );

      test(
        'check all methods called',
        () async {
          const Set<String> deletedItems = {};
          final downloadStream = Stream.value(const <int>[]);

          final downloadedBytes = Uint8List.fromList(const []);

          when(
            () => googleRepository.getFile(target: configuration),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => checksumChecker.getChecksum(),
          ).thenAnswer(
            (_) async => 'not equal to remote checksum',
          );

          when(
            () => googleRepository.downloadFile(googleDriveFile),
          ).thenAnswer(
            (_) async => downloadStream,
          );

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

          when(
            () => deletedItemsProvider.getDeletedItems(),
          ).thenAnswer(
            (_) async => deletedItems,
          );

          when(
            () => repository.migrateWithDatabasePath(
              bytes: downloadedBytes,
              target: configuration.getTarget(pin: pin),
              deleted: deletedItems,
            ),
          ).thenAnswer(
            (_) async => {},
          );

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

          when(() => repository.readAsBytes(
                target: configuration.getTarget(pin: pin),
              )).thenAnswer(
            (_) async => realmDatabaseAsBytes,
          );

          when(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              target: configuration,
            ),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => googleRepository.getFile(target: configuration),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => checksumChecker.setChecksum(
              googleDriveFile.checksum,
            ),
          ).thenAnswer((invocation) async {});

          await usecase.sync(configuration: configuration);

          final verification = verifyInOrder(
            [
              () => googleRepository.getFile(target: configuration),
              () => checksumChecker.getChecksum(),
              () => googleRepository.downloadFile(googleDriveFile),
              () => pinUsecase.getPinOrThrow(),
              () => deletedItemsProvider.getDeletedItems(),
              () => repository.migrateWithDatabasePath(
                    bytes: realmDatabaseAsBytes,
                    target: configuration.getTarget(pin: pin),
                    deleted: deletedItems,
                  ),
              () => pinUsecase.getPinOrThrow(),
              () => repository.readAsBytes(
                    target: configuration.getTarget(pin: pin),
                  ),
              () => googleRepository.updateRemote(
                    realmDatabaseAsBytes,
                    target: configuration,
                  ),
              () => googleRepository.getFile(target: configuration),
              () => checksumChecker.setChecksum(
                    googleDriveFile.checksum,
                  ),
            ],
          );

          expect(verification.length, 11);
        },
      );
      test(
        'check all methods called, throws',
        () async {
          const Set<String> deletedItems = {};
          final downloadStream = Stream.value(const <int>[]);

          final downloadedBytes = Uint8List.fromList(const []);

          when(
            () => googleRepository.getFile(target: configuration),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => checksumChecker.getChecksum(),
          ).thenAnswer(
            (_) async => 'not equal to remote checksum',
          );

          when(
            () => googleRepository.downloadFile(googleDriveFile),
          ).thenAnswer(
            (_) async => downloadStream,
          );

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

          when(
            () => deletedItemsProvider.getDeletedItems(),
          ).thenAnswer(
            (_) async => deletedItems,
          );

          when(
            () => repository.migrateWithDatabasePath(
              bytes: downloadedBytes,
              target: configuration.getTarget(pin: pin),
              deleted: deletedItems,
            ),
          ).thenAnswer(
            (_) async => {},
          );

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

          when(() => repository.readAsBytes(
                target: configuration.getTarget(pin: pin),
              )).thenAnswer(
            (_) async => realmDatabaseAsBytes,
          );

          when(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              target: configuration,
            ),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => googleRepository.getFile(target: configuration),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => checksumChecker.setChecksum(
              googleDriveFile.checksum,
            ),
          ).thenThrow(_Exception());

          final usecaseFuture = usecase.sync(configuration: configuration).then(
            (_) {
              final verification = verifyInOrder(
                [
                  () => googleRepository.getFile(target: configuration),
                  () => checksumChecker.getChecksum(),
                  () => googleRepository.downloadFile(googleDriveFile),
                  () => pinUsecase.getPinOrThrow(),
                  () => deletedItemsProvider.getDeletedItems(),
                  () => repository.migrateWithDatabasePath(
                        bytes: realmDatabaseAsBytes,
                        target: configuration.getTarget(pin: pin),
                        deleted: deletedItems,
                      ),
                  () => pinUsecase.getPinOrThrow(),
                  () => repository.readAsBytes(
                        target: configuration.getTarget(pin: pin),
                      ),
                  () => googleRepository.updateRemote(
                        realmDatabaseAsBytes,
                        target: configuration,
                      ),
                  () => googleRepository.getFile(target: configuration),
                ],
              );

              expect(verification.length, 10);
            },
          );

          expect(usecaseFuture, throwsA(isA<_Exception>()));
        },
      );
    },
  );
}

final class _Exception extends Exception {}
