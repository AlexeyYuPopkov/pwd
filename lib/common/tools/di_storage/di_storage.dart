import 'di_module.dart';
import 'di_storage_entry.dart';
import 'life_time.dart';
export 'life_time.dart';
export 'di_module.dart';

/// RU: [DiStorage] - класс для кеширования обьектов [T]
///
/// EN: [DiStorage] - class for caching objects [T]
///
class DiStorage {
  static DiStorage? _instance;

  DiStorage._();

  static DiStorage get shared => _instance ??= DiStorage._();

  factory DiStorage.another() = DiStorage._;

  late final _constructorsMap = <String, DiStorageEntry>{};

  late final _scopesMap = <String, Set<String>>{};

  /// RU: [bind] - привязка зависимости [T] к фабричному методу
  ///
  /// EN: [bind] - binding [T] dependency to a factory method
  ///
  void bind<T>(
    T Function() constructor, {
    required DiModule? module,
    LifeTime? lifeTime,
  }) {
    final name = T.toString();
    _constructorsMap[name] = DiStorageEntry(
      constructor: constructor,
      lifeTime: lifeTime ?? const LifeTime.prototype(),
    );

    final scopeName = module?.toString();

    if (scopeName != null && _scopesMap.isNotEmpty) {
      var names = _scopesMap[scopeName];

      if (names == null) {
        _scopesMap[scopeName] = {name};
      } else {
        names.add(name);
        _scopesMap[scopeName] = names;
      }
    }
  }

  /// RU: [removeWithName] - удаление зависимости [name] - имя класса
  ///
  /// EN: [removeWithName] - remove the dependency with class [name]
  ///
  // void removeWithName(String name) => _constructorsMap.remove(name);

  /// RU: [remove] - удаление зависимости <T>
  ///
  /// EN: [remove] - remove the dependency with type <T>
  ///
  void remove<T>() => _constructorsMap.remove(T.toString());

  /// RU: [remove] - удаление модуля <T>
  ///
  /// EN: [remove] - remove the dependency with type <T>
  ///
  void removeScope<S extends DiModule>() {
    final scopeName = S.toString();

    final names = _scopesMap[scopeName];

    if (names != null && names.isNotEmpty) {
      for (final instanceName in names) {
        _constructorsMap.remove(instanceName);
      }
    }
  }

  /// RU: [resolve] - разрешение (получение) зависимости с типом <T>
  ///
  /// EN: [resolve] - resolve the dependency with type <T>
  ///
  T resolve<T>() {
    final name = T.toString();

    final box = _constructorsMap[name];

    if (box == null) {
      throw Exception('DiStorage: Forgot bind instance');
    }

    final instance = box.instance;

    if (instance is T) {
      return instance;
    } else {
      final lifeTime = box.lifeTime;

      if (lifeTime is PrototypeLifeTime) {
        return box.constructor();
      } else if (lifeTime is SingleLifeTime) {
        final instance = box.instance;

        if (instance == null) {
          final instance = box.constructor();
          final newBox = box.copyWithInstance(instance);
          _constructorsMap[name] = newBox;
          return newBox.instance!;
        } else {
          return instance;
        }
      } else {
        throw UnimplementedError('DiStorage: Unimplemented object life time');
      }
    }
  }
}
