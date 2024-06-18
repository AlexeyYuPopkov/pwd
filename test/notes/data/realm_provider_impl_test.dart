import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file/memory.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/data/datasource/realm_datasource/realm_provider/create_realm_config_parameters.dart';
import 'package:pwd/notes/data/datasource/realm_datasource/realm_provider/realm_provider_impl.dart';
import '../../test_tools/test_tools.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testMockStorage = 'mock_app_directory';
  const channel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    channel,
    (MethodCall methodCall) async {
      return testMockStorage;
    },
  );

  late RealmProviderImpl sut;
  late FileSystem fileSystem;

  setUp(() {
    fileSystem = MemoryFileSystem();
    sut = RealmProviderImpl(fileSystem);
  });

  Future<void> setupFakeApp(WidgetTester tester) async {
    await tester.pumpWidget(
      CreateApp.createMaterialApp(
        child: const Scaffold(),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('Cache', () {
    testWidgets('CreateRealmConfigPath, cache', (tester) async {
      await setupFakeApp(tester);

      const config = RemoteConfiguration.google(fileName: 'fileName');

      final target = config.getTarget(pin: const Pin(pinSha512: [1]));

      final result = await sut.createRealmConfigPath(
        parameters: CreateRealmConfigParameters.cache(target: target),
      );

      expect(result, '$testMockStorage/fileName');
    });
  });

  group('Temp', () {
    testWidgets('CreateRealmConfigPath, temp', (tester) async {
      await setupFakeApp(tester);

      const config = RemoteConfiguration.google(fileName: 'fileName');

      final target = config.getTarget(pin: const Pin(pinSha512: [1]));

      final result = await sut.createRealmConfigPath(
        parameters: CreateRealmConfigParameters.tmp(
          target: target,
          bytes: Uint8List.fromList([1]),
        ),
      );

      expect(result, '$testMockStorage/fileName_tmp/fileName_tmp');
    });

    testWidgets('deleteTempFolderIfPresent, temp', (tester) async {
      await setupFakeApp(tester);

      const config = RemoteConfiguration.google(fileName: 'fileName');

      final target = config.getTarget(pin: const Pin(pinSha512: [1]));

      final path = await sut.createRealmConfigPath(
        parameters: CreateRealmConfigParameters.tmp(
          target: target,
          bytes: Uint8List.fromList([1]),
        ),
      );

      final file = fileSystem.file(path);
      final folder = file.parent;
      expect(file.existsSync(), true);
      expect(folder.path, '$testMockStorage/fileName_tmp');

      await sut.deleteTempFolderIfPresent(target: target);

      expect(folder.existsSync(), false);
      expect(file.existsSync(), false);
    });
  });
}
