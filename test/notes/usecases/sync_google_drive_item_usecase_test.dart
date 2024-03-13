import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/workflowexecutions/v1.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/google_repository.dart';
import 'package:pwd/notes/domain/model/google_drive_file.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecases_errors.dart';
import 'package:pwd/notes/domain/usecases/sync_google_drive_item_usecase.dart';

class MockGoogleRepository extends Mock implements GoogleRepository {}

class MockRealmLocalRepository extends Mock implements RealmLocalRepository {}

class MockPinUsecase extends Mock implements PinUsecase {}

class MockChecksumChecker extends Mock implements ChecksumChecker {}

void main() {
  late MockGoogleRepository googleRepository;
  late MockRealmLocalRepository repository;
  late MockPinUsecase pinUsecase;
  late MockChecksumChecker checksumChecker;
  late SyncGoogleDriveItemUsecase usecase;

  setUp(() {
    googleRepository = MockGoogleRepository();
    repository = MockRealmLocalRepository();
    pinUsecase = MockPinUsecase();
    checksumChecker = MockChecksumChecker();

    usecase = SyncGoogleDriveItemUsecase(
      remoteRepository: googleRepository,
      realmRepository: repository,
      pinUsecase: pinUsecase,
      checksumChecker: checksumChecker,
    );
  });

  const configuration = GoogleDriveConfiguration(fileName: 'fileName');

  const pin = Pin(
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
    'SyncGoogleDriveItemUsecase: sync, new file should create',
    () {
      test(
        'check all methods called, file == null',
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
              configuration: configuration,
            ),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => checksumChecker.setChecksum(
              googleDriveFile.checksum,
              configuration: configuration,
            ),
          ).thenAnswer((invocation) async {});

          await usecase.execute(configuration: configuration, force: false);

          verifyInOrder(
            [
              () => pinUsecase.getPinOrThrow(),
              () => repository.readAsBytes(
                    target: configuration.getTarget(pin: pin),
                  ),
              () => googleRepository.updateRemote(
                    realmDatabaseAsBytes,
                    configuration: configuration,
                  ),
              () => checksumChecker.setChecksum(
                    googleDriveFile.checksum,
                    configuration: configuration,
                  ),
            ],
          );
        },
      );

      test(
        'check all methods called, file == null, throw',
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
              configuration: configuration,
            ),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => checksumChecker.setChecksum(
              googleDriveFile.checksum,
              configuration: configuration,
            ),
          ).thenThrow(_Exception());

          final result =
              usecase.execute(configuration: configuration, force: false);

          expect(result, throwsA(isA<SyncDataError>()));
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
            () => checksumChecker.getChecksum(
              configuration: configuration,
            ),
          ).thenAnswer(
            (_) async => 'not empty',
          );

          await usecase.execute(configuration: configuration, force: false);

          final verification = verifyInOrder(
            [
              () => googleRepository.getFile(target: configuration),
              () => checksumChecker.getChecksum(
                    configuration: configuration,
                  ),
            ],
          );

          expect(verification.length, 2);

          verifyNever(() => googleRepository.downloadFile(googleDriveFile));
          verifyNever(() => pinUsecase.getPinOrThrow());

          verifyNever(
            () => repository.mergeWithDatabasePath(
              bytes: realmDatabaseAsBytes,
              target: configuration.getTarget(pin: pin),
            ),
          );
          verifyNever(() => repository.readAsBytes(
                target: configuration.getTarget(pin: pin),
              ));

          verifyNever(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              configuration: configuration,
            ),
          );

          verifyNever(() => googleRepository.getFile(target: configuration));

          verifyNever(
            () => checksumChecker.setChecksum(
              googleDriveFile.checksum,
              configuration: configuration,
            ),
          );
        },
      );

      test(
        'check all methods called',
        () async {
          final downloadStream = Stream.value(const <int>[]);

          final downloadedBytes = Uint8List.fromList(const []);

          when(
            () => googleRepository.getFile(target: configuration),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => checksumChecker.getChecksum(
              configuration: configuration,
            ),
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
            () => repository.mergeWithDatabasePath(
              bytes: downloadedBytes,
              target: configuration.getTarget(pin: pin),
            ),
          ).thenAnswer((_) => Future.value());

          when(
            () => repository.creanDeletedIfNeeded(
              target: configuration.getTarget(pin: pin),
            ),
          ).thenAnswer((_) => Future.value());

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

          when(() => repository.readAsBytes(
                target: configuration.getTarget(pin: pin),
              )).thenAnswer(
            (_) async => realmDatabaseAsBytes,
          );

          when(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              configuration: configuration,
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
              configuration: configuration,
            ),
          ).thenAnswer((invocation) async {});

          await usecase.execute(configuration: configuration, force: false);

          final verification = verifyInOrder(
            [
              () => googleRepository.getFile(target: configuration),
              () => checksumChecker.getChecksum(
                    configuration: configuration,
                  ),
              () => googleRepository.downloadFile(googleDriveFile),
              () => pinUsecase.getPinOrThrow(),
              () => repository.mergeWithDatabasePath(
                    bytes: realmDatabaseAsBytes,
                    target: configuration.getTarget(pin: pin),
                  ),
              () => repository.creanDeletedIfNeeded(
                    target: configuration.getTarget(pin: pin),
                  ),
              () => pinUsecase.getPinOrThrow(),
              () => repository.readAsBytes(
                    target: configuration.getTarget(pin: pin),
                  ),
              () => googleRepository.updateRemote(
                    realmDatabaseAsBytes,
                    configuration: configuration,
                  ),
              () => googleRepository.getFile(target: configuration),
              () => checksumChecker.setChecksum(
                    googleDriveFile.checksum,
                    configuration: configuration,
                  ),
            ],
          );

          expect(verification.length, 11);
        },
      );
      test(
        'check all methods called, throws',
        () async {
          final downloadStream = Stream.value(const <int>[]);

          final downloadedBytes = Uint8List.fromList(const []);

          when(
            () => googleRepository.getFile(target: configuration),
          ).thenAnswer(
            (_) async => googleDriveFile,
          );

          when(
            () => checksumChecker.getChecksum(
              configuration: configuration,
            ),
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
            () => repository.mergeWithDatabasePath(
              bytes: downloadedBytes,
              target: configuration.getTarget(pin: pin),
            ),
          ).thenAnswer(
            (_) async => {},
          );

          when(
            () => repository.creanDeletedIfNeeded(
              target: configuration.getTarget(pin: pin),
            ),
          ).thenAnswer((_) => Future.value());

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

          when(() => repository.readAsBytes(
                target: configuration.getTarget(pin: pin),
              )).thenAnswer(
            (_) async => realmDatabaseAsBytes,
          );

          when(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              configuration: configuration,
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
              configuration: configuration,
            ),
          ).thenThrow(_Exception());

          final usecaseFuture = usecase
              .execute(
            configuration: configuration,
            force: false,
          )
              .then(
            (_) {
              final verification = verifyInOrder(
                [
                  () => googleRepository.getFile(target: configuration),
                  () => checksumChecker.getChecksum(
                        configuration: configuration,
                      ),
                  () => googleRepository.downloadFile(googleDriveFile),
                  () => pinUsecase.getPinOrThrow(),
                  () => repository.mergeWithDatabasePath(
                        bytes: realmDatabaseAsBytes,
                        target: configuration.getTarget(pin: pin),
                      ),
                  () => repository.creanDeletedIfNeeded(target: target),
                  () => pinUsecase.getPinOrThrow(),
                  () => repository.readAsBytes(
                        target: configuration.getTarget(pin: pin),
                      ),
                  () => googleRepository.updateRemote(
                        realmDatabaseAsBytes,
                        configuration: configuration,
                      ),
                  () => googleRepository.getFile(target: configuration),
                ],
              );

              expect(verification.length, 10);
            },
          );

          expect(usecaseFuture, throwsA(isA<SyncDataError>()));
        },
      );
    },
  );
}

final class _Exception extends Exception {}
