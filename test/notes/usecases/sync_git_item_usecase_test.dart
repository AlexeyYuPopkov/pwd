import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/workflowexecutions/v1.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/common/domain/usecases/pin_usecase.dart';
import 'package:pwd/notes/domain/checksum_checker.dart';
import 'package:pwd/notes/domain/git_repository.dart';
import 'package:pwd/notes/domain/realm_local_repository.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/get_db_response.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_request.dart';
import 'package:pwd/notes/domain/sync_requests_parameters/put_db_response.dart';
import 'package:pwd/notes/domain/usecases/sync_data_usecases_errors.dart';
import 'package:pwd/notes/domain/usecases/sync_git_item_usecase.dart';

class MockGitRepository extends Mock implements GitRepository {}

class MockRealmLocalRepository extends Mock implements RealmLocalRepository {}

class MockPinUsecase extends Mock implements PinUsecase {}

class MockChecksumChecker extends Mock implements ChecksumChecker {}

void main() {
  late MockGitRepository gitRepository;
  late MockRealmLocalRepository repository;
  late MockPinUsecase pinUsecase;
  late MockChecksumChecker checksumChecker;
  late SyncGitItemUsecase usecase;
  late SyncGitItemUsecaseShaMap shaMap;

  setUp(() {
    gitRepository = MockGitRepository();
    repository = MockRealmLocalRepository();
    pinUsecase = MockPinUsecase();
    checksumChecker = MockChecksumChecker();
    shaMap = SyncGitItemUsecaseShaMap();

    usecase = SyncGitItemUsecase(
      remoteRepository: gitRepository,
      realmRepository: repository,
      pinUsecase: pinUsecase,
      checksumChecker: checksumChecker,
      syncGitItemUsecaseShaMap: shaMap,
    );
  });

  const configuration = GitConfiguration(
    token: '',
    repo: '',
    owner: '',
    branch: '',
    fileName: 'fileName',
  );

  const pin = Pin(
    pinSha512: [],
  );

  final realmDatabaseAsBytes = Uint8List.fromList([]);

  const sha = '123';

  const gitFilePutResponse =
      PutDbResponse(content: PutDbResponseContent(sha: sha));
  const gitFileGetResponse = GetDbResponse(
    sha: sha,
    // content: '',
    // downloadUrl: '',
  );

  final request = PutDbRequest(
    message: SyncGitItemUsecase.commitMessage,
    content: '',
    sha: null,
    committer: SyncGitItemUsecase.committer,
    branch: configuration.branch,
  );
  group(
    'SyncGitItemUsecase: sync, new file should create',
    () {
      test(
        'check all methods called, file == null',
        () async {
          when(
            () => gitRepository.getFile(configuration: configuration),
          ).thenAnswer(
            (_) => Future.value(null),
          );

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);
          when(() => repository.readAsBytes(
                target: configuration.getTarget(pin: pin),
              )).thenAnswer(
            (_) async => realmDatabaseAsBytes,
          );

          final request = PutDbRequest(
            message: SyncGitItemUsecase.commitMessage,
            content: '',
            sha: null,
            committer: SyncGitItemUsecase.committer,
            branch: configuration.branch,
          );

          when(
            () => gitRepository.updateRemote(
              request: request,
              configuration: configuration,
            ),
          ).thenAnswer(
            (_) async => gitFilePutResponse,
          );

          when(
            () => checksumChecker.setChecksum(
              sha,
              configuration: configuration,
            ),
          ).thenAnswer((_) async {});

          await usecase.execute(configuration: configuration, force: false);

          verifyInOrder(
            [
              () => pinUsecase.getPinOrThrow(),
              () => repository.readAsBytes(
                    target: configuration.getTarget(pin: pin),
                  ),
              () => gitRepository.updateRemote(
                    request: request,
                    configuration: configuration,
                  ),
              () => checksumChecker.setChecksum(
                    sha,
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
            () => gitRepository.getFile(configuration: configuration),
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
            () => gitRepository.updateRemote(
              request: request,
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
    'SyncGitItemUsecase: sync, file != null, localChecksum == remoteChecksum',
    () {
      test(
        'sync not needed, check all methods called',
        () async {
          when(
            () => gitRepository.getFile(configuration: configuration),
          ).thenAnswer(
            (_) async => gitFileGetResponse,
          );

          when(
            () => checksumChecker.getChecksum(
              configuration: configuration,
            ),
          ).thenAnswer(
            (_) async => sha,
          );

          await usecase.execute(configuration: configuration, force: false);

          verifyInOrder(
            [
              () => gitRepository.getFile(configuration: configuration),
              () => checksumChecker.getChecksum(
                    configuration: configuration,
                  ),
            ],
          );

          verifyNever(
            () => gitRepository.getRawFile(configuration: configuration),
          );
          verifyNever(() => pinUsecase.getPinOrThrow());

          verifyNever(
            () => repository.mergeWithDatabasePath(
              bytes: realmDatabaseAsBytes,
              target: configuration.getTarget(pin: pin),
            ),
          );
          verifyNever(
            () => repository.readAsBytes(
              target: configuration.getTarget(pin: pin),
            ),
          );

          verifyNever(
            () => gitRepository.updateRemote(
              request: request,
              configuration: configuration,
            ),
          );

          verifyNever(
              () => gitRepository.getFile(configuration: configuration));

          verifyNever(
            () => checksumChecker.setChecksum(
              sha,
              configuration: configuration,
            ),
          );
        },
      );

      test(
        'file != null, localChecksum != remoteChecksum',
        () async {
          when(
            () => gitRepository.getFile(configuration: configuration),
          ).thenAnswer(
            (_) async => gitFileGetResponse,
          );

          when(
            () => checksumChecker.getChecksum(
              configuration: configuration,
            ),
          ).thenAnswer(
            (_) async => 'not equal to remote checksum',
          );

          when(
            () => gitRepository.getRawFile(configuration: configuration),
          ).thenAnswer(
            (_) async => [],
          );

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

          when(
            () => repository.mergeWithDatabasePath(
              bytes: realmDatabaseAsBytes,
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

          final request = PutDbRequest(
            message: SyncGitItemUsecase.commitMessage,
            content: '',
            sha: sha,
            committer: SyncGitItemUsecase.committer,
            branch: configuration.branch,
          );

          when(
            () => gitRepository.updateRemote(
              request: request,
              configuration: configuration,
            ),
          ).thenAnswer(
            (_) async => gitFilePutResponse,
          );

          when(
            () => gitRepository.getFile(configuration: configuration),
          ).thenAnswer(
            (_) async => gitFileGetResponse,
          );

          when(
            () => checksumChecker.setChecksum(
              sha,
              configuration: configuration,
            ),
          ).thenAnswer((invocation) async {});

          await usecase.execute(configuration: configuration, force: false);

          verifyInOrder(
            [
              () => gitRepository.getFile(configuration: configuration),
              () => checksumChecker.getChecksum(
                    configuration: configuration,
                  ),
              () => gitRepository.getRawFile(configuration: configuration),
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
              () => gitRepository.updateRemote(
                    request: request,
                    configuration: configuration,
                  ),
              () => gitRepository.getFile(configuration: configuration),
              () => checksumChecker.setChecksum(
                    sha,
                    configuration: configuration,
                  ),
            ],
          );
        },
      );

      test(
        'file != null, localChecksum != remoteChecksum, throws',
        () async {
          when(
            () => gitRepository.getFile(configuration: configuration),
          ).thenAnswer(
            (_) async => gitFileGetResponse,
          );

          when(
            () => checksumChecker.getChecksum(
              configuration: configuration,
            ),
          ).thenAnswer(
            (_) async => 'not equal to remote checksum',
          );

          when(
            () => gitRepository.getRawFile(configuration: configuration),
          ).thenAnswer(
            (_) async => [],
          );

          when(() => pinUsecase.getPinOrThrow()).thenReturn(pin);

          when(
            () => repository.mergeWithDatabasePath(
              bytes: realmDatabaseAsBytes,
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

          final request = PutDbRequest(
            message: SyncGitItemUsecase.commitMessage,
            content: '',
            sha: sha,
            committer: SyncGitItemUsecase.committer,
            branch: configuration.branch,
          );

          when(
            () => gitRepository.updateRemote(
              request: request,
              configuration: configuration,
            ),
          ).thenAnswer(
            (_) async => gitFilePutResponse,
          );

          when(
            () => gitRepository.getFile(configuration: configuration),
          ).thenAnswer(
            (_) async => gitFileGetResponse,
          );

          when(
            () => checksumChecker.setChecksum(
              sha,
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
}

final class _Exception extends Exception {}
