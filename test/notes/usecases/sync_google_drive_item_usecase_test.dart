import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_storage_configuration.dart';
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
  final googleRepository = MockGoogleRepository();
  final repository = MockRealmLocalRepository();
  final pinUsecase = MockPinUsecase();
  final checksumChecker = MockChecksumChecker();
  final deletedItemsProvider = MockDeletedItemsProvider();

  group(
    'SyncGoogleDriveItemUsecase: updateRemote',
    () {
      test(
        'SyncGoogleDriveItemUsecase: updateRemote check all methods called',
        () async {
          final usecase = SyncGoogleDriveItemUsecase(
            googleRepository: googleRepository,
            realmRepository: repository,
            pinUsecase: pinUsecase,
            checksumChecker: checksumChecker,
            deletedItemsProvider: deletedItemsProvider,
          );

          const configuration = GoogleDriveConfiguration(fileName: 'fileName');

          final pin = Pin(
            pin: '',
            pinSha512: [],
            creationDate: DateTime.now(),
          );

          final realmDatabaseAsBytes = Uint8List.fromList([]);

          final googleDriveFile = GoogleDriveFile(
            id: '',
            checksum: '',
            name: configuration.fileName,
          );

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);
          when(() => repository.readAsBytes(key: pin.pinSha512)).thenAnswer(
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

          verify(() => pinUsecase.getPinOrThrow());
          verify(() => repository.readAsBytes(key: pin.pinSha512));
          verify(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              target: configuration,
            ),
          );
        },
      );

      test(
        'SyncGoogleDriveItemUsecase: updateRemote check all methods called and throws',
        () async {
          final usecase = SyncGoogleDriveItemUsecase(
            googleRepository: googleRepository,
            realmRepository: repository,
            pinUsecase: pinUsecase,
            checksumChecker: checksumChecker,
            deletedItemsProvider: deletedItemsProvider,
          );

          const configuration = GoogleDriveConfiguration(fileName: 'fileName');

          final pin = Pin(
            pin: '',
            pinSha512: [],
            creationDate: DateTime.now(),
          );

          final realmDatabaseAsBytes = Uint8List.fromList([]);

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);
          when(() => repository.readAsBytes(key: pin.pinSha512)).thenAnswer(
            (_) async => realmDatabaseAsBytes,
          );
          when(
            () => googleRepository.updateRemote(
              realmDatabaseAsBytes,
              target: configuration,
            ),
          ).thenAnswer(
            (_) => Future.error(Exception('error')),
          );

          final result = usecase.updateRemote(configuration: configuration);

          expect(result, throwsA(isA<Exception>()));
        },
      );
    },
  );
}
